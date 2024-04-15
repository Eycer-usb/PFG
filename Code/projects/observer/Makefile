# Compiler
CXX := g++

# Compiler flags
CXXFLAGS := -Wall -Wextra -pedantic -std=c++11

# Source files directory
SRC_DIR := src

# Source files
SRC_FILES := $(wildcard $(SRC_DIR)/*.cpp)

# Object files directory
OBJ_DIR := bin

# Object files
OBJ_FILES := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRC_FILES)) \

# Executable file
EXECUTABLE := julietX

# Default target
all: $(OBJ_DIR) $(EXECUTABLE)

# Create the object files directory
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Rule to compile object files from source files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp $(SRC_DIR)/%.hpp
	$(CXX) $(CXXFLAGS) -c $< -o $@


# Rule to link object files and create the executable
$(EXECUTABLE): $(OBJ_FILES) main.cpp
	$(CXX) $(CXXFLAGS) $^ -o $@

# Clean target
clean:
	rm -rf $(OBJ_DIR) $(EXECUTABLE) $(OBJ_DIR)
