defmodule Nova.OrderCommandsTest do
  use Nova.ModelCase
  alias Nova.OrderCommands
  alias Nova.Order

  setup do
    variant = fixtures(:variants).variants.base
    order = fixtures(:orders).orders.base

    {:ok, variant: variant, order: order}
  end

  describe "create/0" do
    it "creates a new order" do
      assert {:ok, %Order{}} = OrderCommands.create
    end
  end

  describe "update/2" do
    it "updates the order", ctx do
      params = %{total: 10.0}
      {:ok, order} = OrderCommands.update(ctx.order.id, params)

      assert %Order{} = order
      assert order.total == Decimal.new(10.0)
    end
  end

  describe "add_line_item/3" do
    it "adds line_item to the order and updates total", ctx do
      {order, variant} = {ctx.order, ctx.variant}
      {:ok, order, _} = OrderCommands.add_line_item(order.id, variant.id, 1)

      assert %Order{} = order
      assert Decimal.compare(order.total, variant.price) == Decimal.new(0)
    end
  end

  describe "update_line_item_quantity/3" do
    it "updates line_item quantity and updates order total", ctx do
      {order, variant} = {ctx.order, ctx.variant}
      {:ok, order, line_item} = OrderCommands.add_line_item(order.id, variant.id, 1)

      {:ok, order, _} = OrderCommands.update_line_item_quantity(order.id, line_item.id, 2)
      new_price = Decimal.mult(variant.price, Decimal.new(2))

      assert %Order{} = order
      assert Decimal.compare(order.total, new_price) == Decimal.new(0)
    end
  end

  describe "remove_line_item/2" do
    it "removes line_item and updates order total", ctx do
      {order, variant} = {ctx.order, ctx.variant}
      {:ok, order, line_item} = OrderCommands.add_line_item(order.id, variant.id, 1)

      {:ok, order, _} = OrderCommands.remove_line_item(order.id, line_item.id)

      assert %Order{} = order
      assert order.total == Decimal.new(0.0)
    end
  end

  describe "delete/1" do
    it "deletes the order", ctx do
      assert %Order{} = OrderCommands.delete(ctx[:order].id)
      refute Repo.get(Order, ctx.order.id)
    end
  end
end
