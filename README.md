# Model Data Generation

## ClassCAD Installation

### Windows

```sh
mkdir -p .classcad && cd .classcad
cmd /c curl https://awvstatic.com/classcad/preview/latest/install-windows-x64.cmd -o "install.cmd"; cmd /c install.cmd; cmd /c del install.cmd
notepad .classcad.appkey # Get a ClassCAD Key from https://beta0121.buerli.io/user/profile and save it to this file
./classcad-cli.cmd hs
```

## Data Generation

> Make sure ClassCAD is running!

> All data will be generated to the `.out` folder.

Content of this repo

```txt
├── asm
│   ├── asc.ccfunc     - The ClassCAD code to build the rack assembly
│   ├── asm.csv        - Parameter input table for the rack assembly
│   └── asm.ps1        - Powershell script that iterates the parameter
│                        table and calls ClassCAD to create the rack assembly
├── column
│   ├── column.ccfunc  - The ClassCAD code to build the column part
│   ├── column.csv     - Parameter input table for the column part
│   └── column.ps1     - Powershell script that iterates the parameter
│                        table and calls ClassCAD to create the column part
├── shelf
│   ├── shelf.ccfunc   - The ClassCAD code to build the shelf part
│   ├── shelf.csv      - Parameter input table for the shelf part
│   ├── shelf.ps1      - Powershell script that iterates the parameter
│   │                    table and calls ClassCAD to create the shelf part
│   └── shelf.py       - Just an example of the usage in python
```

### Column

Execute `column.ps1` to generate the colums.

```sh
cd column
./column.ps1
```

### Shelf

Execute `shelf.ps1` to generate the shelfs.

```sh
cd shelf
./shelf.ps1
```

### Rack assembly

> Columns and shelfs has to be generated before. The rack assembly relies on those models.

Execute `asm.ps1` to generate the rack assemblies.

```sh
cd asm
./asm.ps1
```
