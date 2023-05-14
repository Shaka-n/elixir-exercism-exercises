defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts :: opts) :: {:ok, opts} | {:error, error}
  @callback handle_frame(dot :: dot, frame_number :: frame_number, opts :: opts) :: dot

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation

      def init(opts), do: {:ok, opts}
      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, _opts) do
    opac_modifier = if rem(frame_number, 4) == 0, do: 0.5, else: 1
    %{dot | opacity: dot.opacity * opac_modifier}
  end
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def init(opts) do
    velocity = opts[:velocity]
    if is_number(velocity) do
      {:ok, opts}
    else 
      {:error, "The :velocity option is required, and its value must be a number. Got: #{inspect(velocity)}"}
    end
  end

  @impl DancingDots.Animation
  def handle_frame(dot, 1, _opts), do: dot
  def handle_frame(dot, frame_number, opts) do
    zoom_modifier = dot.radius + (frame_number - 1)* opts[:velocity]
    %{dot | radius: zoom_modifier}
  end
end
