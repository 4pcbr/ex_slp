defmodule ExSlp do
  @on_load :load_nifs

  @error_codes %{
     0  => :SLP_OK,
    -1  => :SLP_LANGUAGE_NOT_SUPPORTED,
    -2  => :SLP_PARSE_ERROR,
    -3  => :SLP_INVALID_REGISTRATION,
    -4  => :SLP_SCOPE_NOT_SUPPORTED,
    -6  => :SLP_AUTHENTICATION_ABSENT,
    -7  => :SLP_AUTHENTICATION_FAILED,
    -13 => :SLP_INVALID_UPDATE,
    -15 => :SLP_REFRESH_REJECTED,
    -17 => :SLP_NOT_IMPLEMENTED,
    -18 => :SLP_BUFFER_OVERFLOW,
    -19 => :SLP_NETWORK_TIMED_OUT,
    -20 => :SLP_NETWORK_INIT_FAILED,
    -21 => :SLP_MEMORY_ALLOC_FAILED,
    -22 => :SLP_PARAMETER_BAD,
    -23 => :SLP_NETWORK_ERROR,
    -24 => :SLP_INTERNAL_SYSTEM_ERROR,
    -25 => :SLP_HANDLE_IN_USE,
    -26 => :SLP_TYPE_ERROR,
  }

  def load_nifs do
    :erlang.load_nif('./c_src/ex_slp', 0)
  end

  def ex_slp_open(_, _) do
    raise "NIF slp_open/2 is not implemented"  
  end

  def open(lang, async) do
    { error_code, handle } = ex_slp_open(lang, case async do
      true  -> 1
      false -> 0
    end)

    case error_code do
      0 -> { :ok, handle }
      _ -> { :error, Map.get(@error_codes, error_code) }
    end

  end

end
