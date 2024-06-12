extends Node
class_name EventBus

signal create_building(building_type)
signal building_created(building_type)
signal building_creation_aborted(building_type)

signal population_updated(population_count)
signal workers_updated(workers_amount)
