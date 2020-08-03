defmodule MemzWeb.ReadingLiveTest do
  use MemzWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Memz.Passages

  @create_attrs %{name: "some name", passage: "some passage", steps: 42}
  @update_attrs %{name: "some updated name", passage: "some updated passage", steps: 43}
  @invalid_attrs %{name: nil, passage: nil, steps: nil}

  defp fixture(:reading) do
    {:ok, reading} = Passages.create_reading(@create_attrs)
    reading
  end

  defp create_reading(_) do
    reading = fixture(:reading)
    %{reading: reading}
  end

  describe "Index" do
    setup [:create_reading]

    test "lists all readings", %{conn: conn, reading: reading} do
      {:ok, _index_live, html} = live(conn, Routes.reading_index_path(conn, :index))

      assert html =~ "Listing Readings"
      assert html =~ reading.name
    end

    test "saves new reading", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.reading_index_path(conn, :index))

      assert index_live |> element("a", "New Reading") |> render_click() =~
               "New Reading"

      assert_patch(index_live, Routes.reading_index_path(conn, :new))

      assert index_live
             |> form("#reading-form", reading: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#reading-form", reading: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.reading_index_path(conn, :index))

      assert html =~ "Reading created successfully"
      assert html =~ "some name"
    end

    test "updates reading in listing", %{conn: conn, reading: reading} do
      {:ok, index_live, _html} = live(conn, Routes.reading_index_path(conn, :index))

      assert index_live |> element("#reading-#{reading.id} a", "Edit") |> render_click() =~
               "Edit Reading"

      assert_patch(index_live, Routes.reading_index_path(conn, :edit, reading))

      assert index_live
             |> form("#reading-form", reading: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#reading-form", reading: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.reading_index_path(conn, :index))

      assert html =~ "Reading updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes reading in listing", %{conn: conn, reading: reading} do
      {:ok, index_live, _html} = live(conn, Routes.reading_index_path(conn, :index))

      assert index_live |> element("#reading-#{reading.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#reading-#{reading.id}")
    end
  end

  describe "Show" do
    setup [:create_reading]

    test "displays reading", %{conn: conn, reading: reading} do
      {:ok, _show_live, html} = live(conn, Routes.reading_show_path(conn, :show, reading))

      assert html =~ "Show Reading"
      assert html =~ reading.name
    end

    test "updates reading within modal", %{conn: conn, reading: reading} do
      {:ok, show_live, _html} = live(conn, Routes.reading_show_path(conn, :show, reading))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Reading"

      assert_patch(show_live, Routes.reading_show_path(conn, :edit, reading))

      assert show_live
             |> form("#reading-form", reading: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#reading-form", reading: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.reading_show_path(conn, :show, reading))

      assert html =~ "Reading updated successfully"
      assert html =~ "some updated name"
    end
  end
end
