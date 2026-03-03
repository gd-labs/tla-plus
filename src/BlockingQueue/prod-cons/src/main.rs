use std::{
    collections::VecDeque,
    sync::{Arc, Condvar, Mutex},
    thread,
};

use clap::Parser;

#[derive(clap::Parser, Debug)]
struct Args {
    #[arg(default_value_t = 3)]
    buffer_size: usize,

    #[arg(default_value_t = 4)]
    producer_count: usize,

    #[arg(default_value_t = 3)]
    consumer_count: usize,
}

fn main() {
    let Args {
        buffer_size,
        producer_count,
        consumer_count,
    } = Args::parse();

    let buf = {
        let inner = VecDeque::with_capacity(buffer_size);
        Arc::new((Mutex::new(inner), Condvar::new()))
    };

    let producers: Vec<_> = (0..producer_count)
        .map(|i| {
            let buf = Arc::clone(&buf);
            thread::spawn(move || {
                loop {
                    let (lock, condvar) = &*buf;

                    let mut buf = lock.lock().unwrap();
                    while buf.len() == buf.capacity() {
                        buf = condvar.wait(buf).unwrap();
                    }
                    buf.push_back(format!("prod {}: item {}", i, i));
                    condvar.notify_one();
                }
            })
        })
        .collect();

    let consumers: Vec<_> = (0..consumer_count)
        .map(|i| {
            let buf = Arc::clone(&buf);
            thread::spawn(move || {
                loop {
                    let (lock, condvar) = &*buf;

                    let mut buf = lock.lock().unwrap();
                    while buf.is_empty() {
                        buf = condvar.wait(buf).unwrap();
                    }
                    let item = buf.pop_front().unwrap();
                    condvar.notify_one();
                    println!("cons {}: item {{{}}}", i, item);
                }
            })
        })
        .collect();

    for producer in producers {
        producer.join().unwrap();
    }

    for consumer in consumers {
        consumer.join().unwrap();
    }
}
