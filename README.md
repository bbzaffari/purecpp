# PureCPP framework
**PureCPP** is the C++ backend for architectural code that powers the RAG system.

---

## 📖 Documentation
For detailed installation and setup instructions, please refer to our official documentation:

🔗 [PureCPP Documentation](https://docs.puredocs.org/setup)

---

## 🚀 Contributing to PureCPP

We welcome contributions to **PureCPP**! If you would like to contribute, please read our contribution guide before opening an issue or submitting a pull request:

👉 [Contribution Guide](/community/CONTRIBUTING.md)

---

## 📌 Minimum Requirements

Ensure you have the following dependencies installed before building PureCPP:

- **GCC/G++** 13.1
- **CMake** 3.22
- **Conan** 2
- **Rust**

---
# Environment Setup (Ubuntu / Debian) for C++ and Python Development

## 1. Clone the Repository

```bash
git clone --recursive https://github.com/pureai-ecosystem/purecpp.git
cd purecpp
````

> **Note:**  
> If you forgot to use `--recursive` when cloning the repository,  
> make sure to run:
>
> ```bash
> git submodule update --init --recursive
> ```
>
> This will initialize and update all required Git submodules.

## 2. Installing dependencies

Run the following commands:

```bash
sudo apt update && \
sudo apt upgrade -y && \
sudo apt install -y  build-essential nano wget \
    curl ninja-build cmake libopenblas-dev \
    libgflags-dev python3-dev libprotobuf-dev \
    protobuf-compiler
````

---

## 3. Install python essential packages

*In case you do not have a Docker environment available*, we strongly recommend that you use a Python `venv` (virtual environment) to ensure proper isolation of dependencies and reproducibility of results. This practice minimizes conflicts between global packages and project-specific requirements, fostering a cleaner and more maintainable development setup. 

Steps below to create and activate the virtual environment:

  - Create the virtual environment (replace 'venv' with your preferred name)
    ```bash
    python3 -m venv venv
    ````
  - Activate the virtual environment on Linux or macOS
    ```bash
    source venv/bin/activate
    ````

```bash
pip install build conan cmake requests pybind11
````
---

## 4. Execute the FAISS installation script

```bash
chmod +X installers/install_faiss_ubuntu.sh
./installers/install_faiss_ubuntu.sh
````

---

## 5. Install Rust via rustup

### Run rustup installer non-interactively (-y). This places cargo and rustc in /root/.cargo.
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
````

### Activate Rust Environment:
```bash
source ~/.cargo/env
````

---

## 6. Setting the Default Conan Profile

To ensure Conan has a working default configuration, run:

```bash
conan profile detect --force
````

### What does this command do?

* It **creates the folder**:

  ```
  ~/.conan2/
  ```

* It **generates the default profile file**:

  ```
  ~/.conan2/profiles/default
  ```

* It **automatically detects and writes** your system’s configuration, including:

  * Operating system (`os`)
  * Architecture (`arch`)
  * Compiler (`compiler`, `compiler.version`, `compiler.cppstd`, `compiler.libcxx`)
  * Build type (`build_type`)

This is necessary for Conan to correctly resolve and build C++ dependencies on your system.

### 🔍 Locating the profile file

If you want to verify the path of the `default` profile, run:

```bash
find ~ -type d -wholename "*/.conan2/profiles"
```

> **Note:** By default, this will be under:
>
> ```
> /home/<user>/.conan2/profiles/
> ```

### Editing the profile

Once you’ve located the `default` profile, you can edit it to explicitly set the following configuration:

```
[settings]
arch=x86_64
build_type=Release
compiler=gcc
compiler.cppstd=17
compiler.libcxx=libstdc++11
compiler.version=11
os=Linux
```

---

## 7. Use pre-trained models

### 🛠️ Hugging Face to **ONNX** Converter 

**`models_to_onnx.py`**

This is a unified Python script to convert Hugging Face models into the ONNX format for optimized inference.

The script handles two main use cases:
1. **Feature extraction models** (e.g., `sentence-transformers`).
2. **Token classification models** (e.g., Named Entity Recognition - NER).

It automatically creates a `models` directory (in the parent folder of the script) to store the exported ONNX models and related assets.

### Requirements

Before running the script, make sure you have the following Python packages installed:

```bash
pip install torch transformers onnx onnxruntime optimum
```

### 🔧 How to Use

| Argument          | Description                                           |
| ----------------- | ----------------------------------------------------- |
| `-m` / `--model`  | Hugging Face model name (e.g., `dslim/bert-base-NER`) |
| `-o` / `--output` | Output folder name                                    |
| `--mode`          | `feature` or `token` (default: `token`)               |
| `--base_dir`      | Base save directory (default: `./models`)             |

---

## 🚀 Examples

```bash
python model_to_onnx.py -m="dbmdz/bert-large-cased-finetuned-conll03-english" -o="bert-large-cased-finetuned-conll03-english"
```

```bash
python model_to_onnx.py -m="sentence-transformers/all-MiniLM-L6-v2" -o="sentence-transformers/all-MiniLM-L6-v2"
```

## Output

```
/models/ 
  ├── sentence-transformers/all-MiniLM-L6-v2/ 
  │    ├── model.onnx (via optimum)
  │    └── tokenizer/ 
  └── dslim/bert-base-NER/  
       ├── model.onnx  
       ├── label_map.json  
       └── tokenizer/ 
```

---

# How to build 

Before running the provided shell scripts, ensure they have the appropriate execution permissions. This step is essential to avoid permission errors during the build process, especially when working on Linux or macOS systems.

```bash
chmod +x ./all_cmake.sh
chmod +x ./module_cmake.sh
````

## Compile all at once
```
./all_cmake.sh
```

## Compile one at time
```
./module_cmake.sh <module>
```

The resulting libraries will be placed inside `Sandbox` dir

```
Sandbox/
├── purecpp_chunks_clean.cpython-312-x86_64-linux-gnu.so
└── ...
```

Use this directory to load, test, and iterate on the library code.


## 📌 Next Steps
![Next Steps](community/release.jpg)

Stay tuned for updates! 🚀