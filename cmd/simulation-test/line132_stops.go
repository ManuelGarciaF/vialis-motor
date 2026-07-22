package main

import (
	"strconv"

	"github.com/ManuelGarciaF/vialis-motor/internal/simulation"
)

func line132Stops() stopList {
	positions := []simulation.Position{
		{Latitude: -34.586005, Longitude: -58.373625},
		{Latitude: -34.58946, Longitude: -58.372723},
		{Latitude: -34.59197, Longitude: -58.37447},
		{Latitude: -34.596508, Longitude: -58.37217},
		{Latitude: -34.59871, Longitude: -58.375872},
		{Latitude: -34.598962, Longitude: -58.380002},
		{Latitude: -34.59917, Longitude: -58.38462},
		{Latitude: -34.599332, Longitude: -58.388537},
		{Latitude: -34.599565, Longitude: -58.392142},
		{Latitude: -34.59968, Longitude: -58.396525},
		{Latitude: -34.599565, Longitude: -58.400222},
		{Latitude: -34.599415, Longitude: -58.404047},
		{Latitude: -34.601615, Longitude: -58.404737},
		{Latitude: -34.604228, Longitude: -58.405417},
		{Latitude: -34.607122, Longitude: -58.406105},
		{Latitude: -34.609642, Longitude: -58.405982},
		{Latitude: -34.610177, Longitude: -58.406542},
	}

	stops := make(stopList, len(positions))
	for index, position := range positions {
		stops[index] = simulation.Stop{
			ID:       strconv.Itoa(index + 1),
			Position: position,
		}
	}
	return stops
}
