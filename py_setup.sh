#!/bin/bash

# LLM-generated Script to set up Python virtual environment and install dependencies

echo "================================"
echo "Python Environment Setup"
echo "================================"
echo ""

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed. Please install Python 3 first."
    exit 1
fi

echo "Python version:"
python3 --version
echo ""

# Create virtual environment
VENV_DIR="venv"
if [ -d "$VENV_DIR" ]; then
    echo "Virtual environment '$VENV_DIR' already exists."
    read -p "Do you want to remove it and create a new one? (y/N): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "Removing existing virtual environment..."
        rm -rf "$VENV_DIR"
    else
        echo "Using existing virtual environment."
    fi
fi

if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment in '$VENV_DIR'..."
    
    # 1. Try standard creation
    if python3 -m venv "$VENV_DIR"; then
        echo "Virtual environment created successfully."
    else
        echo "Standard creation failed (likely missing python3-venv)."
        echo "Attempting to create without pip..."
        
        # 2. Create venv WITHOUT pip
        python3 -m venv "$VENV_DIR" --without-pip
        
        # 3. Manually install pip
        echo "Downloading and installing pip manually..."
        source "$VENV_DIR/bin/activate"
        
        # Download get-pip.py using curl or wget
        if command -v curl &> /dev/null; then
            curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        elif command -v wget &> /dev/null; then
            wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py
        else
            echo "Error: Neither curl nor wget found. Cannot install pip."
            exit 1
        fi
        
        # Run the pip installer
        python get-pip.py
        rm get-pip.py
        
        # Deactivate to allow the main script to reactivate properly later
        deactivate
    fi
fi
echo ""

# Activate virtual environment
echo "Activating virtual environment..."
source "$VENV_DIR/bin/activate"
if [ $? -ne 0 ]; then
    echo "Error: Failed to activate virtual environment."
    exit 1
fi
echo "Virtual environment activated."
echo ""

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip
echo ""

# Install requirements
if [ -f "requirements.txt" ]; then
    echo "Installing dependencies from requirements.txt..."
    pip install -r requirements.txt
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install dependencies."
        exit 1
    fi
    echo ""
    echo "All dependencies installed successfully!"
else
    echo "Warning: requirements.txt not found."
    echo "Installing common packages manually..."
    pip install numpy pandas matplotlib
fi
echo ""

# Display installed packages
echo "Installed packages:"
pip list
echo ""

echo "================================"
echo "Setup Complete!"
echo "================================"
echo ""
echo "To activate the virtual environment in the future, run:"
echo "  source venv/bin/activate"
echo ""
echo "To deactivate the virtual environment, run:"
echo "  deactivate"
echo ""
