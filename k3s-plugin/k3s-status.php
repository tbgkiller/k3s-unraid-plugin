<?php
header("Content-Type: application/json; charset=utf-8");
header("Cache-Control: no-cache, no-store, must-revalidate");
header("Pragma: no-cache");
header("Expires: 0");

$pid_file = "/boot/config/plugins/k3s-plugin/state/k3s.pid";

function k3s_is_running($pid_file) {
    if (!file_exists($pid_file)) {
        return false;
    }

    $pid = trim((string) file_get_contents($pid_file));
    return $pid !== "" && ctype_digit($pid) && file_exists("/proc/{$pid}");
}

function k3s_node_output($is_running) {
    if (!$is_running) {
        return "k3s is currently stopped.\nStart the service to populate cluster node data.";
    }

    $output = shell_exec("/usr/local/bin/k3s kubectl get nodes -o wide 2>&1");
    $trimmed = trim((string) $output);

    if ($trimmed === "") {
        return "No node data returned from k3s.";
    }

    return $trimmed;
}

$is_running = k3s_is_running($pid_file);
$node_output = k3s_node_output($is_running);

echo json_encode([
    "running" => $is_running,
    "status" => $is_running ? "Running" : "Stopped",
    "status_message" => $is_running ? "The k3s server process is active." : "The k3s server process is not running.",
    "node_summary" => $is_running ? "Live cluster response" : "Waiting for service start",
    "nodes" => $node_output,
    "checked_at" => date(DATE_ATOM),
], JSON_UNESCAPED_SLASHES);
