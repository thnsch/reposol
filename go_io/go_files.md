# Go: Reading and Writing Files & Streams

Modules
```
import (
    "bufio"
    "fmt"
    "io"
    "os"
)
```

## Files

### Writing to a file
```
func main() {

    content := "Hello!\nThis is a test file."

    err := os.WriteFile("test_output.txt", []byte(content), 0644)   // Create or overwrite
    if err != nil {
        fmt.Println("Error writing file:", err)
        return
    }

    fmt.Println("File written successfully.")
```

### Reading the entire file
```
    data, err := os.ReadFile("test_output.txt")
    if err != nil {
        fmt.Println("Error reading file:", err)
        return
    }
    fmt.Println("File content as string:")
    fmt.Println(string(data))
```


### Reading file line by line
```
    file, err := os.Open("test_output.txt")
    if err != nil {
        fmt.Println("Error opening file:", err)
        return
    }
    defer file.Close()

    fmt.Println("Reading file line by line:")
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        fmt.Println(scanner.Text())
    }

    if err := scanner.Err(); err != nil {
        fmt.Println("Scanner error:", err)
    }
```

## Files using a stream

### Writing to a file using a stream
    f, err := os.Create("stream_output.txt")
    if err != nil {
        fmt.Println("Error creating file:", err)
        return
    }
    defer f.Close()

    writer := bufio.NewWriter(f)
    _, err = writer.WriteString("This is buffered output.\n")
    if err != nil {
        fmt.Println("Error writing:", err)
        return
    }
    writer.Flush() // must flush to ensure write

### Reading with streams (chunks)
    fmt.Println("Reading file in chunks:")
    streamFile, err := os.Open("test_output.txt")
    if err != nil {
        fmt.Println("Error opening file:", err)
        return
    }
    defer streamFile.Close()

    buf := make([]byte, 16)
    for {
        n, err := streamFile.Read(buf)
        if err == io.EOF {
            break
        } else if err != nil {
            fmt.Println("Read error:", err)
            break
        }
        fmt.Print(string(buf[:n]))
    }
}
