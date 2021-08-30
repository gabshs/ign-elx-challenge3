defmodule GenReport do
  alias GenReport.Parser

  @names [
    "cleiton",
    "daniele",
    "danilo",
    "diego",
    "giuliano",
    "jakeliny",
    "joseph",
    "mayk",
    "rafael",
    "vinicius"
  ]

  @months %{
    "1" => "janeiro",
    "2" => "fevereiro",
    "3" => "março",
    "4" => "abril",
    "5" => "maio",
    "6" => "junho",
    "7" => "julho",
    "8" => "agosto",
    "9" => "setembro",
    "10" => "outubro",
    "11" => "novembro",
    "12" => "dezembro"
  }

  def build, do: {:error, "Insira o nome de um arquivo"}

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(gen_report(), fn line, report -> sum_hours(line, report) end)
  end

  defp sum_hours([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => per_month,
         "hours_per_year" => per_year
       }) do
    total_hours = Map.put(all_hours, name, all_hours[name] + hours)

    months_worked = Map.put(per_month[name], month, per_month[name][month] + hours)
    hours_per_month = Map.put(per_month, name, months_worked)

    hours_per_year = Map.put(per_year[name], year, per_year[name][year] + hours)
    years_worked = Map.put(per_year, name, hours_per_year)

    %{
      "all_hours" => total_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => years_worked
    }
  end

  def gen_report do
    all_hours = Enum.into(@names, %{}, &{&1, 0})

    hours_per_month = Enum.into(@names, %{}, &{&1, insert_month_to_name()})

    hours_per_year = Enum.into(@names, %{}, &{&1, insert_years_to_name()})

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp insert_month_to_name do
    @months
    |> Enum.map(fn {_key, value} -> value end)
    |> Enum.into(%{}, &{&1, 0})
  end

  defp insert_years_to_name do
    Enum.into(2016..2020, %{}, &{&1, 0})
  end
end
