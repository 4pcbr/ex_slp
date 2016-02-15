#include <string.h>
#include <assert.h>

#include "/usr/local/Cellar/openslp/2.0.0/include/slp.h"
#include "/usr/local/lib/erlang/erts-7.2.1/include/erl_nif.h"

//#include "slp.h"
//#include "erl_nif.h"


ErlNifResourceType *NIF_SLP_HANDLE;

void handle_destructor(ErlNifEnv *env, void *handle) {
  //TODO
}

int load(ErlNifEnv *env, void **priv_data, ERL_NIF_TERM load_info) {
  int flags = ERL_NIF_RT_CREATE | ERL_NIF_RT_TAKEOVER;
  NIF_SLP_HANDLE = enif_open_resource_type(env, NULL, "handle", handle_destructor, flags, NULL);
  if (NIF_SLP_HANDLE == NULL) return -1;
  return 0;
}

static ERL_NIF_TERM
ex_slp_open(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
  char         *lang;
  char         *ret_code;
  int           isasync;
  unsigned int  term_len;
  SLPHandle    *slp_handle;
  SLPEXP SLPError SLPAPI error;

  if (enif_is_binary(env, argv[0])) {
    if (enif_get_string(env, argv[0], lang, sizeof(argv[0]), ERL_NIF_LATIN1) < 0) {
      return enif_make_badarg(env);
    }
  } else if (enif_is_atom(env, argv[0])) {

    if (enif_get_atom_length(env, argv[0], &term_len, ERL_NIF_LATIN1) < 0) {
      return enif_make_badarg(env);
    }

    if (enif_get_atom(env, argv[0], lang, term_len, ERL_NIF_LATIN1) < 0) {
      return enif_make_badarg(env);
    }
  }

  if ( ! enif_get_int(env, argv[1], &isasync)) return enif_make_badarg(env);

  slp_handle = enif_alloc_resource(NIF_SLP_HANDLE, sizeof(SLPHandle));
  if (slp_handle == NULL) return enif_make_badarg(env);

  error = SLPOpen(lang, isasync > 0 ? SLP_TRUE : SLP_FALSE, slp_handle);

  ERL_NIF_TERM term = enif_make_resource(env, slp_handle);
  enif_release_resource(slp_handle);

  return enif_make_tuple2(env, enif_make_int(env, error), term);
}

static ERL_NIF_TERM
ex_slp_close(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
  SLPHandle ** slp_handle_res;
  enif_get_resource(env, argv[0], NIF_SLP_HANDLE, (void *) slp_handle_res);
  SLPHandle *slp_handle = *slp_handle_res;
  if (slp_handle == NULL) return enif_make_badarg(env);
  SLPClose(slp_handle);
  return enif_make_int(env, 0);
}

static ErlNifFunc nif_funcs[] = {
  {"ex_slp_open", 2, ex_slp_open},
  {"ex_slp_close", 1, ex_slp_close},
};

ERL_NIF_INIT(Elixir.ExSlp.Nif, nif_funcs, &load, NULL, NULL, NULL);

