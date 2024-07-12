extends Node
class_name EventBus

signal create_building(building_type)
signal building_created(building_type)
signal building_creation_aborted(building_type)

signal population_updated(population_count)
signal available_workers_updated(available_workers_amount)

signal resource_updated(resource_type, resource_amount)
signal resource_prodution_rate_updated(resource_type, production_rate)

signal money_updated(money_amount)
signal money_production_rate_updated(money_production_rate)
