# Identicon

An identicon application exploring functional programming in Elixir with the following functions:
main/1  
save_image/2  
draw_image/1  
build_pixel_map/1  
filter_odd_squares/1  
build_grid/1  
mirror_row/1  
pick_color/1  
hash_input/1  

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `identicon` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:identicon, "~> 0.1.0"}]
    end
    ```

  2. Ensure `identicon` is started before your application:

    ```elixir
    def application do
      [applications: [:identicon]]
    end
    ```

