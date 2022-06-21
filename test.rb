require 'perlin_noise'
require 'colorize'

def perlin_2d(interval: 150, frequency: 0.1, sea_level: 0, scaling: 0, octave_1: 1, octave_2: 0.5, octave_3: 0.25)
  contrast = Perlin::Curve.contrast(Perlin::Curve::QUINTIC, scaling)

  noises_1 = Perlin::Noise.new 2, :interval => interval
  noises_2 = Perlin::Noise.new 2, :interval => interval
  noises_3 = Perlin::Noise.new 2, :interval => interval

  90.times do |x|
    interval.times do |y|
      n = octave_1 * noises_1[x * frequency / octave_1, y * frequency / octave_1]
      n += octave_2 * noises_2[x * frequency / octave_2, y * frequency / octave_2] if octave_2 > 0
      n += octave_3 * noises_3[x * frequency / octave_3, y * frequency / octave_3] if octave_3 > 0

      n = n / (octave_1 + octave_2 + octave_3)
      n = contrast.call n
      # n = n ** scaling

      print tile n, sea_level
    end

    puts
  end
end

def tile(n, sea_level)
  bars = ' ▁▂▃▄▅▆▇█'.chars

  return bars[-1].blue if n <= sea_level

  scaled_value = [
    (n - sea_level) / (1 - sea_level),
    0
  ].max

  bar_length = [
    (bars.length * scaled_value).floor,
    (bars.length - 1)
  ].min

  bar = bars[bar_length]
  case bar_length
  when 0
    bars[0].on_light_green
  else
    bar
  end
end

return pp String.colors

perlin_2d :frequency => 0.02, :interval => 300, :octave_2 => 0.2, :octave_3 => 0.05, scaling: 1, sea_level: 0.5

### TODO ###
# Fix map not wrapping properly (interval?)
# Better colors
# Coastal / oceanic sea depth (with colors)
# General polish
