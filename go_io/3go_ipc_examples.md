# Go IPC Examples: Unix Domain Sockets, Named Pipes, net.Pipe

```
package main

import (
    "bufio"
    "fmt"
    "io"
    "net"
    "os"
    "os/exec"
    "time"
)
```

## 1 Unix domain socket client/server
```
func unixSocketServer(socketPath string) {    // Unix domain socket server
    os.Remove(socketPath)
    ln, err := net.Listen("unix", socketPath)
    if err != nil {
        fmt.Println("Listen error:", err)
        return
    }
    defer ln.Close()

    conn, err := ln.Accept()
    if err != nil {
        fmt.Println("Accept error:", err)
        return
    }
    defer conn.Close()

    io.Copy(os.Stdout, conn)
}

func unixSocketClient(socketPath string) {    // Unix domain socket client
    conn, err := net.Dial("unix", socketPath)
    if err != nil {
        fmt.Println("Dial error:", err)
        return
    }
    defer conn.Close()

    conn.Write([]byte("Hello from Unix socket client!\n"))
}

func main() {
    fmt.Println("== Unix domain socket IPC ==")
    socketPath := "/tmp/demo_socket"
    go unixSocketServer(socketPath)
    time.Sleep(500 * time.Millisecond)
    unixSocketClient(socketPath)
}
```

## 2. Named pipe example (FIFO)
```
fmt.Println("== Named pipe (FIFO) ==")

pipePath := "/tmp/demo_pipe"

os.Remove(pipePath)
err := os.MkdirAll("/tmp", 0755)
if err != nil {
    fmt.Println("mkdir error:", err)
    return
}

err = syscallMkfifo(pipePath, 0666)
if err != nil {
    fmt.Println("mkfifo error:", err)
    return
}

// Simulate a writer
go func() {
    f, _ := os.OpenFile(pipePath, os.O_WRONLY, os.ModeNamedPipe)
    defer f.Close()
    f.WriteString("Data via named pipe\n")
}()

// Reader
f, _ := os.OpenFile(pipePath, os.O_RDONLY, os.ModeNamedPipe)
defer f.Close()
io.Copy(os.Stdout, f)

// syscall.Mkfifo alternative for cross-compilation clarity
func syscallMkfifo(path string, mode uint32) error {
    return syscallMkfifoUnix(path, mode)
}

```

## 3. net.Pipe: in-memory bi-directional pipe
```
fmt.Println("== In-memory net.Pipe ==")

c1, c2 := net.Pipe()

go func() {
    fmt.Fprintln(c1, "Hello from net.Pipe writer")
    c1.Close()
}()

io.Copy(os.Stdout, c2)
c2.Close()
```

## 4. Using os/exec with pipes (child process communication)
```
fmt.Println("== exec.Command with pipe ==")

cmd := exec.Command("echo", "Data from subprocess")
stdout, _ := cmd.StdoutPipe()

cmd.Start()
io.Copy(os.Stdout, stdout)
cmd.Wait()
```
