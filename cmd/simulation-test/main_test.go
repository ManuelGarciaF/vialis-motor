package main

import (
	"testing"
)

func TestLine132Stops(t *testing.T) {
	stops := line132Stops()
	if len(stops) != 17 {
		t.Fatalf("stop count = %d, want 17", len(stops))
	}
	if stops[0].ID != "1" || stops[0].Position.Latitude != -34.586005 || stops[0].Position.Longitude != -58.373625 {
		t.Fatalf("first stop = %#v, want line 132 stop 1", stops[0])
	}
	last := stops[len(stops)-1]
	if last.ID != "17" || last.Position.Latitude != -34.610177 || last.Position.Longitude != -58.406542 {
		t.Fatalf("last stop = %#v, want line 132 stop 17", last)
	}
}

func TestStopListFirstCustomStopReplacesDefaults(t *testing.T) {
	stops := defaultStops.clone()
	if err := stops.Set("X,-34.60,-58.40"); err != nil {
		t.Fatalf("Set() error = %v", err)
	}

	if len(stops) != 1 {
		t.Fatalf("stop count = %d, want 1", len(stops))
	}
	if stops[0].ID != "X" || stops[0].Position.Latitude != -34.60 || stops[0].Position.Longitude != -58.40 {
		t.Fatalf("stop = %#v, want parsed custom stop", stops[0])
	}
}

func TestStopListKeepsCustomStopOrder(t *testing.T) {
	var stops stopList
	for _, value := range []string{"A,-34.60,-58.40", "B,-34.61,-58.41"} {
		if err := stops.Set(value); err != nil {
			t.Fatalf("Set(%q) error = %v", value, err)
		}
	}

	if len(stops) != 2 || stops[0].ID != "A" || stops[1].ID != "B" {
		t.Fatalf("stops = %#v, want A followed by B", stops)
	}
}

func TestStopListRejectsInvalidValue(t *testing.T) {
	var stops stopList
	if err := stops.Set("A,-34.60"); err == nil {
		t.Fatal("Set() error = nil, want invalid-format error")
	}
	if err := stops.Set("A,latitude,-58.40"); err == nil {
		t.Fatal("Set() error = nil, want invalid-latitude error")
	}
}
