extends Node
class_name EventBus

# ask UI -> MODEL
# send MODEL -> UI

## BUILDING
signal ask_create_building(building_id)
signal send_building_created(building_id)
signal send_building_creation_aborted(building_id)

signal send_building_selected(building_node)

## POPULATION / WORKER
signal population_updated(population_count)
signal available_workers_updated(available_workers_amount)

## RESOURCES
signal resource_updated(resource_type, resource_amount)
signal resource_prodution_rate_updated(resource_type, production_rate)

## MONEY
signal money_updated(money_amount)
signal money_production_rate_updated(money_production_rate)

## ORDER
signal ask_create_new_order(resource_type)
signal send_create_new_order(resource_type)

signal ask_remove_order(resource_type)
signal send_remove_order(resource_type)

signal ask_update_order_buy(resource_type, buy_amount)
signal send_update_order_buy(resource_type, buy_amount)

signal ask_update_order_sell(resource_type, sell_amount)
signal send_update_order_sell(resource_type, sell_amount)
