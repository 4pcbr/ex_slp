defmodule ExSlp.Nif do
  @on_load :load_nifs

  def load_nifs do
    nif_path = case :code.priv_dir(:ex_slp) do
      { :error, :bad_name } ->
        case :filelib.is_dir(:filename.join(["..", "..", :priv])) do
          true ->
            :filename.join(["..", "..", :priv, :ex_slp])
          _ ->
            :filename.join(["..", :priv, :ex_slp])
        end
      dir ->
        :filename.join(dir, :ex_slp)
    end

    :erlang.load_nif(nif_path, 0)
  end

  def ex_slp_open(_, _) do
    raise "NIF slp_open/2 is not implemented"
  end

  def ex_slp_close(_) do
    raise "NIF slp_close/1 is not implemented"
  end

end


