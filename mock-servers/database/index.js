const express = require('express');

const app = express();
const PORT = 3003;

let nodeMasterMap = {
    "node1.example.com": "master1",
    "node2.example.com": "master2",
    "node3.example.com": "master1",
    "node4.example.com": "master2"
};

// todo: get node-masters from masters
// randomly shuffle masters
setInterval(() => {
    for (let node in nodeMasterMap) {
        nodeMasterMap[node] = Math.random() > 0.5 ? "master1" : "master2";
    }
    console.log('Node master map updated');
}, 60000);

app.get('/', (req, res) => {
    try {
        res.json(nodeMasterMap);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error processing request');
    }
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on http://0.0.0.0:${PORT}`);
});