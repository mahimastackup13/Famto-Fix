import 'package:flutter/material.dart';

import 'package:famto_mini_booking/models/service.dart';
import 'package:famto_mini_booking/models/service_category.dart';

class MockData {
  MockData._();

  static const List<ServiceCategory> categories = [
    ServiceCategory(
      id: 'electrician',
      name: 'Electrician',
      tagline: 'Wiring, fans & fittings',
      icon: Icons.electrical_services,
      color: Color(0xFFF59E0B),
      imagePath: 'assets/images/categories/electrician.png',
    ),
    ServiceCategory(
      id: 'plumber',
      name: 'Plumber',
      tagline: 'Taps, leaks & drains',
      icon: Icons.plumbing,
      color: Color(0xFF0EA5E9),
      imagePath: 'assets/images/categories/plumber.png',
    ),
    ServiceCategory(
      id: 'ac_repair',
      name: 'AC Repair',
      tagline: 'Service, gas & install',
      icon: Icons.ac_unit,
      color: Color(0xFF14B8A6),
      imagePath: 'assets/images/categories/ac_repair.png',
    ),
    ServiceCategory(
      id: 'cleaning',
      name: 'Cleaning',
      tagline: 'Deep clean your home',
      icon: Icons.cleaning_services,
      color: Color(0xFF22C55E),
      imagePath: 'assets/images/categories/cleaning.png',
    ),
    ServiceCategory(
      id: 'appliance',
      name: 'Appliances',
      tagline: 'Fridge, washer & more',
      icon: Icons.local_laundry_service,
      color: Color(0xFF8B5CF6),
      imagePath: 'assets/images/categories/appliance.png',
    ),
    ServiceCategory(
      id: 'painting',
      name: 'Painting',
      tagline: 'Walls, ceilings & more',
      icon: Icons.format_paint,
      color: Color(0xFFEF4444),
      imagePath: 'assets/images/categories/painting.png',
    ),
  ];

  static const List<Service> services = [
    // Electrician
    Service(
      id: 'el_fan',
      categoryId: 'electrician',
      name: 'Ceiling Fan Repair & Installation',
      description:
          'Our verified electrician installs a new ceiling fan or repairs '
          'noise, wobble, speed and regulator problems. Tested before we leave.',
      price: 349,
      rating: 4.7,
      reviewCount: 312,
      durationMinutes: 45,
      inclusions: ['Fan fitting or repair', 'Regulator check', 'Safety testing'],
    ),
    Service(
      id: 'el_switch',
      categoryId: 'electrician',
      name: 'Switchboard & Wiring Fix',
      description:
          'Fix sparking, loose or burnt switches and sockets, and replace '
          'damaged wiring safely with quality parts.',
      price: 499,
      rating: 4.6,
      reviewCount: 187,
      durationMinutes: 60,
      inclusions: ['Switch/socket replacement', 'Wiring inspection', 'Load check'],
    ),
    Service(
      id: 'el_light',
      categoryId: 'electrician',
      name: 'Light & Fixture Installation',
      description:
          'Mount tube lights, chandeliers, wall lamps or LED panels with '
          'neat wiring and a clean finish.',
      price: 299,
      rating: 4.8,
      reviewCount: 254,
      durationMinutes: 40,
      inclusions: ['Mounting & wiring', 'Bulb/driver testing', 'Cleanup'],
    ),
    Service(
      id: 'el_inspect',
      categoryId: 'electrician',
      name: 'Home Electrical Safety Inspection',
      description:
          'A complete safety audit of your MCB box, earthing, wiring and '
          'appliances, with a clear report of what needs attention.',
      price: 799,
      rating: 4.9,
      reviewCount: 98,
      durationMinutes: 90,
      inclusions: ['MCB & earthing check', 'Thermal spot checks', 'Written report'],
    ),
    // Plumber
    Service(
      id: 'pl_tap',
      categoryId: 'plumber',
      name: 'Tap & Mixer Repair',
      description:
          'Stop drips and replace faulty taps, mixers, showers and '
          'cartridges. Includes minor fittings.',
      price: 249,
      rating: 4.6,
      reviewCount: 421,
      durationMinutes: 30,
      inclusions: ['Leak diagnosis', 'Washer/cartridge change', 'Water-flow test'],
    ),
    Service(
      id: 'pl_leak',
      categoryId: 'plumber',
      name: 'Pipe Leakage Repair',
      description:
          'Locate and fix leaking concealed or exposed pipes, joints and '
          'valves with minimal mess.',
      price: 449,
      rating: 4.5,
      reviewCount: 203,
      durationMinutes: 60,
      inclusions: ['Leak detection', 'Joint/pipe repair', 'Pressure test'],
    ),
    Service(
      id: 'pl_drain',
      categoryId: 'plumber',
      name: 'Blocked Drain Cleaning',
      description:
          'Clear blocked kitchen sinks, washbasins and bathroom drains '
          'using professional tools.',
      price: 399,
      rating: 4.7,
      reviewCount: 266,
      durationMinutes: 50,
      inclusions: ['Drain unclogging', 'Trap cleaning', 'Flow test'],
    ),
    Service(
      id: 'pl_tank',
      categoryId: 'plumber',
      name: 'Water Tank Cleaning',
      description:
          'Hygienic mechanical cleaning and disinfection of overhead or '
          'underground tanks up to 1000 litres.',
      price: 899,
      rating: 4.8,
      reviewCount: 142,
      durationMinutes: 120,
      inclusions: ['Sludge removal', 'Disinfection', 'Rinse & refill check'],
    ),
    // AC repair
    Service(
      id: 'ac_service',
      categoryId: 'ac_repair',
      name: 'AC General Service',
      description:
          'Jet-pump cleaning of filters, coils and drain for better cooling '
          'and lower power bills. Split or window AC.',
      price: 599,
      rating: 4.8,
      reviewCount: 689,
      durationMinutes: 60,
      inclusions: ['Filter & coil cleaning', 'Drain flush', 'Cooling check'],
    ),
    Service(
      id: 'ac_gas',
      categoryId: 'ac_repair',
      name: 'AC Gas Refill & Leak Fix',
      description:
          'Detect leaks, repair and refill refrigerant gas to restore full '
          'cooling performance.',
      price: 2499,
      rating: 4.6,
      reviewCount: 175,
      durationMinutes: 90,
      inclusions: ['Leak detection', 'Gas top-up', 'Pressure & cooling test'],
    ),
    Service(
      id: 'ac_install',
      categoryId: 'ac_repair',
      name: 'AC Installation',
      description:
          'Professional wall mounting of a split AC with pipe fitting, '
          'vacuuming and a demo.',
      price: 1499,
      rating: 4.7,
      reviewCount: 233,
      durationMinutes: 120,
      inclusions: ['Indoor/outdoor mounting', 'Pipe & wiring', 'Trial run'],
    ),
    // Cleaning
    Service(
      id: 'cl_home',
      categoryId: 'cleaning',
      name: 'Full Home Deep Cleaning',
      description:
          'Top-to-bottom cleaning of floors, windows, fans, kitchen and '
          'bathrooms by a trained team with machines.',
      price: 3499,
      rating: 4.8,
      reviewCount: 512,
      durationMinutes: 240,
      inclusions: ['All rooms & balcony', 'Kitchen & bathrooms', 'Eco-safe products'],
    ),
    Service(
      id: 'cl_bath',
      categoryId: 'cleaning',
      name: 'Bathroom Deep Cleaning',
      description:
          'Remove limescale, stains and odour from tiles, fittings and '
          'sanitary ware.',
      price: 599,
      rating: 4.7,
      reviewCount: 398,
      durationMinutes: 60,
      inclusions: ['Tile & grout scrub', 'Fittings polish', 'Disinfection'],
    ),
    Service(
      id: 'cl_kitchen',
      categoryId: 'cleaning',
      name: 'Kitchen Deep Cleaning',
      description:
          'Degrease chimney, hob, tiles, cabinets and sink for a spotless, '
          'hygienic kitchen.',
      price: 999,
      rating: 4.7,
      reviewCount: 301,
      durationMinutes: 120,
      inclusions: ['Degreasing', 'Cabinet exterior', 'Sink & counter'],
    ),
    // Appliances
    Service(
      id: 'ap_washer',
      categoryId: 'appliance',
      name: 'Washing Machine Repair',
      description:
          'Diagnosis and repair for top and front-load machines: drainage, '
          'spin, noise and error codes.',
      price: 399,
      rating: 4.5,
      reviewCount: 220,
      durationMinutes: 60,
      inclusions: ['Fault diagnosis', 'Minor repair', '30-day warranty'],
    ),
    Service(
      id: 'ap_fridge',
      categoryId: 'appliance',
      name: 'Refrigerator Repair',
      description:
          'Fix cooling issues, ice build-up, leakage and strange noises on '
          'single and double door fridges.',
      price: 449,
      rating: 4.6,
      reviewCount: 190,
      durationMinutes: 75,
      inclusions: ['Cooling diagnosis', 'Minor repair', '30-day warranty'],
    ),
  ];
}
