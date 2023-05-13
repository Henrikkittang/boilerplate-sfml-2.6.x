

LIB := C:/SFML-2.6.X/SFML-2.6.x-build-gnu/lib
SFML_GRAPHICS := $(LIB)/libsfml-graphics-s.a \
				 $(LIB)/libsfml-window-s.a \
				 $(LIB)/libsfml-system-s.a \
				 C:/SFML-2.6.x/windows/libfreetype.a \
				 -l opengl32 -l winmm -l gdi32 \

INCLUDE := C:/SFML-2.6.x/SFML-2.6.x/include

DEBUG_PATH   = build/debug/main
RELEASE_PATH = build/release/main
SOURCE 	     = src/main.cpp

# Flags for all modes
CC        = g++
# CPPFLAGS  = -std=gnu++17 -stdlib=libstdc++ -femulated-tls  -pthread 
CPPFLAGS  = -std=c++17 
STATIC    = SFML_STATIC

DEBUG_FLAGS   = -g
RELEASE_FLAGS = -O3 
# RELEASE_FLAGS = -Ofast -ftree-vectorize -march=native -finline-functions 


# //////////////////////////////////
#            Debug
# //////////////////////////////////

build-debug: compile-debug link-debug
all-debug: build-debug run-debug

compile-debug:
	@echo ">>> Compiling debug..."
	${CC} ${CPPFLAGS} $(DEBUG_FLAGS) -D $(STATIC) -I $(INCLUDE) -c $(SOURCE) -o $(DEBUG_PATH).o 
link-debug:
	@echo ">>> Linking debug..."
	${CC} ${CPPFLAGS} $(DEBUG_FLAGS)  $(DEBUG_PATH).o -o $(DEBUG_PATH).exe -L lib $(SFML_GRAPHICS) -lpthread
run-debug:
	@echo ">>> Running debug..."
	$(DEBUG_PATH).exe
	

clean-debug:
	@echo ">>> Cleaning..."
	rm -f build/debug/*.o build/debug/*.exe

assembly-debug:
	${CC} ${CPPFLAGS} $(DEBUG_FLAGS) -S -I $(INCLUDE) -c $(SOURCE) -o main_debug.s

profile-debug:
	@echo ">>> Compiling debug..."
	${CC} ${CPPFLAGS} $(DEBUG_FLAGS) -I $(INCLUDE) -c $(SOURCE) -o $(DEBUG_PATH).o  -pg -no-pie
	
	@echo ">>> Linking debug..."
	${CC} ${CPPFLAGS} $(DEBUG_FLAGS) $(DEBUG_PATH).o -o $(DEBUG_PATH).exe -L -lpthread $(SFML_GRAPHICS) -pg -no-pie

	@echo ">>> Profiling debug..."
	$(DEBUG_PATH).exe 
	gprof $(DEBUG_PATH).exe gmon.out > analysis.txt   



# //////////////////////////////////
#            Release
# //////////////////////////////////

build-release: compile-release link-release
all-release: build-release run-release

assembly-release:
	${CC} ${CPPFLAGS} $(RELEASE_FLAGS) -D $(STATIC)  -I $(INCLUDE) -c $(SOURCE) -o main_release.s

compile-release:
	@echo ">>> Compiling release..."
	${CC} ${CPPFLAGS} $(RELEASE_FLAGS) -D $(STATIC) -I $(INCLUDE) -c $(SOURCE) -o $(RELEASE_PATH).o  
link-release:
	@echo ">>> Linking release..."
	${CC} ${CPPFLAGS} $(RELEASE_FLAGS) $(RELEASE_PATH).o -o $(RELEASE_PATH).exe -L -lpthread  $(SFML_GRAPHICS) 
run-release:
	@echo ">>> Running release..."
	$(RELEASE_PATH).exe

clean-release:
	@echo ">>> Cleaning release..."
	rm -f build/release/*.o build/release/*.exe

profile-release:
	@echo ">>> Compiling release..."
	${CC} ${CPPFLAGS} $(RELEASE_FLAGS) -D $(STATIC) -I $(INCLUDE) -c $(SOURCE) -o $(RELEASE_PATH).o -pg  -no-pie
	
	@echo ">>> Linking release..."
	${CC} ${CPPFLAGS} $(RELEASE_FLAGS) $(RELEASE_PATH).o -o $(RELEASE_PATH).exe -L -lpthread $(SFML_GRAPHICS) -pg  -no-pie
	
	@echo ">>> Profiling release..."
	$(RELEASE_PATH).exe 
	gprof $(RELEASE_PATH).exe gmon.out > analysis.txt
	



