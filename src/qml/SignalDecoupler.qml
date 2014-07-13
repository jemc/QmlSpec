
import QtQuick 2.1


WorkerScript {
  source: "SignalDecoupler.worker.js"
  
  signal triggered()
  onMessage: triggered()
  
  function trigger() { sendMessage({}) }
}
