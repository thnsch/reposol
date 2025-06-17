## 1. VSCode Integration with Go

Once you're comfortable using Go in the terminal, here's how to set up Visual Studio Code for a productive Go development experience.

### 1.1 Install the Go extension

- Open VSCode
- Go to the Extensions tab (Ctrl+Shift+X)
- Search for **"Go" by Go Team at Google**
- Install it

### 1.2 Configure settings (optional)

Go to Settings (Ctrl+,) and search for "Go". \
Recommended settings:

- `go.useLanguageServer`: true
- `go.formatTool`: goimports or gofmt
- `go.lintTool`: staticcheck or golint
- `go.testFlags`: ["-v"]
- `go.toolsManagement.autoUpdate`: true

### 1.3 Environment variables in VSCode

Ensure VSCode picks up your terminal settings. You can:

- Launch VSCode from the terminal where your environment is already set (`code .`)
- Or define your environment variables in:
    - `~/.bashrc`, `~/.zshrc`, or
    - VSCode settings: `.vscode/settings.json`

Example `.vscode/settings.json`:
```json
{
  "go.gopath": "/home/your_user/go",
  "go.toolsEnvVars": {
    "GOPATH": "/home/your_user/go",
    "GO111MODULE": "on"
  }
}
```
Example `.../your_workspace.code-workspace`:
```json
{
  ... ,
  "settings": {
    "git.enabled": true,
    "terminal.integrated.shellIntegration.enabled": false,
    "terminal.integrated.gpuAcceleration": "off",
    "go.gopath": "/home/your_user/go",
    "go.toolsEnvVars": {
      "GOPATH": "/home/your_user/go",
      "GO111MODULE": "on"
    },
    "[go]": {
      "editor.insertSpaces": true,
      "editor.detectIndentation": true,
      "editor.formatOnSave": true,
      "editor.codeActionsOnSave": {
        "source.sortImports": "explicit"
      }
    }
  }
}
```

### 1.4 Debugging with VSCode

1. Create a `launch.json` via the Run and Debug tab > "create a launch.json file"
2. Use the "Go: Launch file" template
3. Examples: \
`launch.json`
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch Go App",
      "type": "go",
      "request": "launch",
      "mode": "auto",
      "program": "${file}",
      "env": {	    	// environment variables for debug process
				"GOPATH": "/home/your_user/go"
      },
      "args": [],
      "showLog": true
    }
  ]
}

``` 
Alternatively in your workspace file `.../your_workspace.code-workspace` 
```json
{
  ... ,
  "launch": {
    "version": "0.2.0",
    "configurations": [
      {
        "name": "Launch Go App",
        "type": "go",
        "request": "launch",
        "mode": "auto",
        "program": "${file}",
        "env": {	    	// environment variables for debug process
  				"GOPATH": "/home/your_user/go"
        },
        "args": [],
        "showLog": true
      }
    ]
  }
```

You can now
- Set breakpoints
- Hover to inspect variables
- Step through code

VSCode makes Go development smoother with 
- Autocompletion
- Documentation on hover
- Refactoring tools
- Live linting
