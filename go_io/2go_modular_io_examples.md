# Modular Go I/O Examples for IPC-style usage

```
package main

import (
    "bufio"
    "bytes"
    "fmt"
    "io"
    "net"
    "os"
    "strings"
    "time"
)
```

## PipeExample demonstrates io.Pipe
```
fmt.Println("== io.Pipe ==")

r, w := io.Pipe()
go func() {
    w.Write([]byte("streamed via io.Pipe\n"))
    w.Close()
}()

io.Copy(os.Stdout, r)

```

## BufferExample demonstrates bytes.Buffer
```
fmt.Println("== bytes.Buffer ==")

var b bytes.Buffer
b.WriteString("Hello ")
b.WriteString("buffered world!")
fmt.Println(b.String())
```

## StringReaderExample demonstrates strings.Reader
```
fmt.Println("== strings.Reader ==")

sr := strings.NewReader("This is a string reader.\n")
io.Copy(os.Stdout, sr)
```

## ChannelExample demonstrates channel-based message queue
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

## StdinEchoExample reads from stdin and echoes to stdout
```
fmt.Println("== echo from stdin ==")

fmt.Println("Type something and press Enter (20 characters max):")
go func() {
    time.Sleep(5 * time.Second)
    fmt.Println("\n(timeout - moving on)")
}()
io.CopyN(os.Stdout, os.Stdin, 20)
```

## MultiWriterExample demonstrates io.MultiWriter
```
fmt.Println("== io.MultiWriter ==")

file, _ := os.Create("multi_output.txt")
defer file.Close()
mw := io.MultiWriter(os.Stdout, file)
mw.Write([]byte("Writing to stdout and file together!\n"))

```

## NetPipeExample simulates network communication using net.Pipe
```
fmt.Println("== net.Pipe ==")

conn1, conn2 := net.Pipe()
go func() {
    writer := bufio.NewWriter(conn1)
    writer.WriteString("Hello from one end\n")
    writer.Flush()
    conn1.Close()
}()
io.Copy(os.Stdout, conn2)
conn2.Close()
```
