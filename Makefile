ERL_INCLUDE_PATH=/usr/local/lib/erlang/erts-7.2.1/include
OPENSLP_INCLUDE_PATH=/usr/local/Cellar/openslp/2.0.0/include
OPENSLP_LIB_PATH=/usr/local/Cellar/openslp/2.0.0/lib

all: priv/ex_slp.so

priv/ex_slp.so: c_src/ex_slp.c
	cc -fPIC -I$(ERL_INCLUDE_PATH) -I$(OPENSLP_INCLUDE_PATH) -L$(OPENSLP_LIB_PATH) -lslp -dynamiclib -undefined dynamic_lookup -o priv/ex_slp.so c_src/ex_slp.c -v
