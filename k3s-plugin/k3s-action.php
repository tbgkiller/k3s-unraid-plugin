<?php
header("Content-Type: application/json; charset=utf-8");
header("Cache-Control: no-cache, no-store, must-revalidate");
header("Pragma: no-cache");
header("Expires: 0");

$plugin_dir = "/boot/config/plugins/k3s-plugin";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    http_response_code(405);
    echo json_encode([
        "success" => false,
        "message" => "Method not allowed.",
    ], JSON_UNESCAPED_SLASHES);
    exit;
}

$action = isset($_POST["action"]) ? trim((string) $_POST["action"]) : "";
$scripts = [
    "start" => "{$plugin_dir}/start.sh",
    "stop" => "{$plugin_dir}/stop.sh",
];

if (!array_key_exists($action, $scripts)) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Invalid action requested.",
    ], JSON_UNESCAPED_SLASHES);
    exit;
}

$output = [];
$exit_code = 0;
exec("bash " . escapeshellarg($scripts[$action]) . " 2>&1", $output, $exit_code);

echo json_encode([
    "success" => $exit_code === 0,
    "action" => $action,
    "message" => $exit_code === 0
        ? ucfirst($action) . " command finished."
        : ucfirst($action) . " command failed.",
    "output" => trim(implode("\n", $output)),
], JSON_UNESCAPED_SLASHES);
