# Go I/O: Pipes, Buffers, Channels, and more

```
package main

import (
    "bytes"
    "fmt"
    "io"
    "net"
    "os"
    "strings"
    "time"
)

func main() {

```

## io.Pipe (connect reader and writer)
```
    fmt.Println("== io.Pipe ==")
    r, w := io.Pipe()

    go func() {
        w.Write([]byte("streamed via io.Pipe\n"))
        w.Close()
    }()

    io.Copy(os.Stdout, r)
```

## bytes.Buffer (in-memory writer)
```
    fmt.Println("== bytes.Buffer ==")
    var b bytes.Buffer
    b.WriteString("Hello ")
    b.WriteString("buffered world!")
    fmt.Println(b.String())
```

## strings.Reader (in-memory reader)
```
    fmt.Println("== strings.Reader ==")
    sr := strings.NewReader("This is a string reader.")
    io.Copy(os.Stdout, sr)
    fmt.Println()
```

## Channels (Go-style message queue)
```
fmt.Println("== channels ==")
ch := make(chan string)
go func() {
    ch <- "message from goroutine"
    close(ch)
}()
for msg := range ch {
    fmt.Println(msg)
}
```

## os.Stdin to os.Stdout echo
```
fmt.Println("== echo from stdin (type something and press Enter) ==")
go func() {
    time.Sleep(5 * time.Second)
    fmt.Println("\n(timeout - moving on)")
}()
io.CopyN(os.Stdout, os.Stdin, 20)
```

## io.MultiWriter (write to multiple outputs)
```
fmt.Println("== io.MultiWriter ==")
file, _ := os.Create("multi_output.txt")
defer file.Close()
mw := io.MultiWriter(os.Stdout, file)   # like the tee command
mw.Write([]byte("Writing to stdout and file together!\n"))
```

## Simulated net.Conn (mock TCP)
```
fmt.Println("== net.Pipe (mock network connection) ==")
conn1, conn2 := net.Pipe()
go func() {
    conn1.Write([]byte("Hello from one end\n"))
    conn1.Close()
}()
io.Copy(os.Stdout, conn2)
conn2.Close()
```
