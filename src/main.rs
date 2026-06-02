use std::sync::{Arc, Mutex, mpsc};
use std::thread;
use std::time::Duration;

#[derive(Debug, Clone)]
pub struct PerformanceProfile {
    pub max_threads: usize,
    pub memory_limit_mb: usize,
}

impl PerformanceProfile {
    pub fn standard_mobile() -> Self {
        Self { max_threads: 7, memory_limit_mb: 2560 }
    }
}

#[derive(Debug)]
pub enum PipelineSignal {
    AgentStarted(String),
    DataPayload { agent_name: String, data: String },
    AgentCompleted(String),
    Error(String),
}

pub struct IsolatedTask {
    pub name: String,
    pub memory_cost_mb: usize,
    pub payload_to_send: String, 
}

pub struct SandboxScheduler {
    profile: PerformanceProfile,
    active_memory_mb: Arc<Mutex<usize>>,
}

impl SandboxScheduler {
    pub fn new(profile: PerformanceProfile) -> Self {
        Self { profile, active_memory_mb: Arc::new(Mutex::new(0)) }
    }

    pub fn execute(&self, task: IsolatedTask, tx: mpsc::Sender<PipelineSignal>) {
        let mem_limit = self.profile.memory_limit_mb;
        let shared_mem = Arc::clone(&self.active_memory_mb);

        thread::spawn(move || {
            {
                let mut current_mem = shared_mem.lock().unwrap();
                if *current_mem + task.memory_cost_mb > mem_limit {
                    let _ = tx.send(PipelineSignal::Error(format!("OOM Prevented for {}", task.name)));
                    return;
                }
                *current_mem += task.memory_cost_mb;
            }

            let _ = tx.send(PipelineSignal::AgentStarted(task.name.clone()));
            thread::sleep(Duration::from_millis(800));

            let _ = tx.send(PipelineSignal::DataPayload {
                agent_name: task.name.clone(),
                data: task.payload_to_send,
            });

            {
                let mut current_mem = shared_mem.lock().unwrap();
                *current_mem -= task.memory_cost_mb;
            }
            let _ = tx.send(PipelineSignal::AgentCompleted(task.name));
        });
    }
}

fn main() {
    println!("====================================================");
    println!("   NEXUS_OS I/O MESSAGE BUS (CLEAN CORE)            ");
    println!("====================================================");

    let profile = PerformanceProfile::standard_mobile();
    let scheduler = SandboxScheduler::new(profile);
    let (tx, rx) = mpsc::channel();

    let agents = vec![
        IsolatedTask { 
            name: "Alpha_Philosophy_Agent".to_string(), 
            memory_cost_mb: 300, 
            payload_to_send: "Concept: Dissipative Flow is established.".to_string() 
        },
        IsolatedTask { 
            name: "Alpha_Math_Agent".to_string(), 
            memory_cost_mb: 500, 
            payload_to_send: "Equation 2.7 -> Tropical Circle Min-Plus bounds calculated.".to_string() 
        },
    ];

    for agent in agents {
        scheduler.execute(agent, tx.clone());
    }

    drop(tx); 

    println!("[+] Main Event Loop Listening for Signals...\n");

    for signal in rx {
        match signal {
            PipelineSignal::AgentStarted(name) => println!("  [>] SIGNAL: Agent '{}' Booted.", name),
            PipelineSignal::DataPayload { agent_name, data } => println!("  [📥] DATA from '{}': {}", agent_name, data),
            PipelineSignal::AgentCompleted(name) => println!("  [<] SIGNAL: Agent '{}' Safely Terminated.", name),
            PipelineSignal::Error(err) => println!("  [❌] SYSTEM ERROR: {}", err),
        }
    }

    println!("\n====================================================");
    println!("   ALL AGENT COMMUNICATIONS COMPLETED SUCCESSFULLY  ");
    println!("====================================================");
}
