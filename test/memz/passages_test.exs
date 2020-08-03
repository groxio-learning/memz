defmodule Memz.PassagesTest do
  use Memz.DataCase

  alias Memz.Passages

  describe "readings" do
    alias Memz.Passages.Reading

    @valid_attrs %{name: "some name", passage: "some passage", steps: 42}
    @update_attrs %{name: "some updated name", passage: "some updated passage", steps: 43}
    @invalid_attrs %{name: nil, passage: nil, steps: nil}

    def reading_fixture(attrs \\ %{}) do
      {:ok, reading} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Passages.create_reading()

      reading
    end

    test "list_readings/0 returns all readings" do
      reading = reading_fixture()
      assert Passages.list_readings() == [reading]
    end

    test "get_reading!/1 returns the reading with given id" do
      reading = reading_fixture()
      assert Passages.get_reading!(reading.id) == reading
    end

    test "create_reading/1 with valid data creates a reading" do
      assert {:ok, %Reading{} = reading} = Passages.create_reading(@valid_attrs)
      assert reading.name == "some name"
      assert reading.passage == "some passage"
      assert reading.steps == 42
    end

    test "create_reading/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Passages.create_reading(@invalid_attrs)
    end

    test "update_reading/2 with valid data updates the reading" do
      reading = reading_fixture()
      assert {:ok, %Reading{} = reading} = Passages.update_reading(reading, @update_attrs)
      assert reading.name == "some updated name"
      assert reading.passage == "some updated passage"
      assert reading.steps == 43
    end

    test "update_reading/2 with invalid data returns error changeset" do
      reading = reading_fixture()
      assert {:error, %Ecto.Changeset{}} = Passages.update_reading(reading, @invalid_attrs)
      assert reading == Passages.get_reading!(reading.id)
    end

    test "delete_reading/1 deletes the reading" do
      reading = reading_fixture()
      assert {:ok, %Reading{}} = Passages.delete_reading(reading)
      assert_raise Ecto.NoResultsError, fn -> Passages.get_reading!(reading.id) end
    end

    test "change_reading/1 returns a reading changeset" do
      reading = reading_fixture()
      assert %Ecto.Changeset{} = Passages.change_reading(reading)
    end
  end
end
