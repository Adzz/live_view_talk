defmodule Domain.Request do
  defmodule Step do
    @enforce_keys [:action, :on_error]
    defstruct @enforce_keys
  end

  @enforce_keys [:state, :steps, :on_error]
  defstruct [:state, :steps, :on_error, errors: [], valid?: true]

  def new(state, on_error \\ & &1) do
    %Domain.Request{state: state, steps: [], on_error: on_error}
  end

  def add_to_state(request, key, fun) do
    with {:ok, result} <- fun.(request.state) do
      state = Map.merge(request.state, %{key => result})
      {:ok, %{request | state: state}}
    end
  end

  def add_steps(request = %__MODULE__{}, steps) do
    Enum.reduce(steps, request, fn
      {step, options}, acc -> add_step(acc, step, options)
      step, acc -> add_step(acc, step, [])
    end)
  end

  def add_step(request = %__MODULE__{}, action, options \\ []) do
    step = %Domain.Request.Step{
      action: action,
      on_error: Keyword.get(options, :on_error, request.on_error)
    }

    %{request | steps: request.steps ++ [step]}
  end

  def fail_fast(req = %Domain.Request{steps: steps}) do
    steps
    |> Enum.reduce_while(req, fn step = %Domain.Request.Step{}, acc ->
      with {:ok, result = %Domain.Request{}} <- step.action.(acc) do
        {:cont, result}
      else
        {:error, message} -> {:halt, {:error, message}}
      end
    end)
  end

  def validate(request, validation_fun) do
    case validation_fun.(request.state) do
      {:ok, _} -> {:ok, request}
      error = {:error, _} -> error
    end
  end

  def unwrap(req = %{valid?: true}, on_success, _on_error), do: on_success.(req)
  def unwrap(req = %{valid?: false}, _on_success, on_error), do: on_error.(req)
end
