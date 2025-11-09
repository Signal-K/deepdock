---
sticker: lucide//contrast
tags:
  - Database
  - Station-98
kanban-plugin: basic
Project:
  - Station-98
---
# Events collection
Objects of interest:
1. `url`
2. `name`
3. `status`:
	1. `abbrev`
	2. `description` 
4. `updates`
5. `weather_concerns`
6. `launch_provider`
7. `rocket`
	1. `configuration`
	2. `variant`
8. `mission`
	1. `description`
	2. `type`
	3. `orbit`
	4. `agencies` - should be a FK pointing to `launch_providers collection`
9. `pad`
10. `infoUrls`
	1. `url`
11. `vidUrls`

(We'll need a new collection for `rockets` with the basic information for the generic rocket model, and then a way to show the specific instance of that model).
(We'll also need a new collection for `pads`).

Example configuration:
```sql
**HTTP 200 OK**
**Allow:** GET
**Content-Type:** application/json
**Vary:** Accept

{
    "id": "e8e93778-657c-401c-9c88-3cd4c7c45c9d",
    "url": "[https://ll.thespacedevs.com/2.2.0/launch/e8e93778-657c-401c-9c88-3cd4c7c45c9d/](https://ll.thespacedevs.com/2.2.0/launch/e8e93778-657c-401c-9c88-3cd4c7c45c9d/)",
    "slug": "falcon-9-block-5-dragon-crs-2-spx-33",
    "flightclub_url": "[https://flightclub.io/result?llId=e8e93778-657c-401c-9c88-3cd4c7c45c9d](https://flightclub.io/result?llId=e8e93778-657c-401c-9c88-3cd4c7c45c9d)",
    "r_spacex_api_id": null,
    "name": "Falcon 9 Block 5 | Dragon CRS-2 SpX-33",
    "status": {
        "id": 3,
        "name": "Launch Successful",
        "abbrev": "Success",
        "description": "The launch vehicle successfully inserted its payload(s) into the target orbit(s)."
    },
    "last_updated": "2025-08-24T07:18:06Z",
    "updates": [
        {
            "id": 11965,
            "profile_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/lucas2520stauder_profile_20230526163835.jpg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/lucas2520stauder_profile_20230526163835.jpg)",
            "comment": "Launch successful.",
            "info_url": "[https://www.youtube.com/watch?v=qk1JnExKcoo](https://www.youtube.com/watch?v=qk1JnExKcoo)",
            "created_by": "hitura-nobad",
            "created_on": "2025-08-24T07:03:00Z"
        },
        {
            "id": 11964,
            "profile_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/lucas2520stauder_profile_20230526163835.jpg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/lucas2520stauder_profile_20230526163835.jpg)",
            "comment": "Liftoff!",
            "info_url": "[https://www.youtube.com/watch?v=qk1JnExKcoo](https://www.youtube.com/watch?v=qk1JnExKcoo)",
            "created_by": "hitura-nobad",
            "created_on": "2025-08-24T06:46:00Z"
        },
        {
            "id": 11963,
            "profile_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/ll2_profile_20230311134739.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/ll2_profile_20230311134739.png)",
            "comment": "Official Webcast by NASA has started",
            "info_url": "[https://www.youtube.com/watch?v=qk1JnExKcoo](https://www.youtube.com/watch?v=qk1JnExKcoo)",
            "created_by": "LL2",
            "created_on": "2025-08-24T06:25:00Z"
        },
        {
            "id": 11953,
            "profile_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png)",
            "comment": "Tweaked T-0.",
            "info_url": "[https://www.spacex.com/launches/crs33](https://www.spacex.com/launches/crs33)",
            "created_by": "Cosmic_Penguin",
            "created_on": "2025-08-23T07:09:00Z"
        },
        {
            "id": 11951,
            "profile_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png)",
            "comment": "Weather is 70% favorable for launch.",
            "info_url": "[https://45thweathersquadron.nebula.spaceforce.mil/assets/LaunchForecasts/Falcon%209%20CRS-33%20L-1%20Forecast%20-%2024%20Aug%20Launch.pdf](https://45thweathersquadron.nebula.spaceforce.mil/assets/LaunchForecasts/Falcon%209%20CRS-33%20L-1%20Forecast%20-%2024%20Aug%20Launch.pdf)",
            "created_by": "Cosmic_Penguin",
            "created_on": "2025-08-22T19:11:00Z"
        },
        {
            "id": 11933,
            "profile_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png)",
            "comment": "Tweaked T-0.",
            "info_url": "[https://nasa-public-data.s3.amazonaws.com/iss-coords/current/ISS_OEM/ISS.OEM_J2K_EPH.txt](https://nasa-public-data.s3.amazonaws.com/iss-coords/current/ISS_OEM/ISS.OEM_J2K_EPH.txt)",
            "created_by": "Cosmic_Penguin",
            "created_on": "2025-08-21T17:43:00Z"
        },
        {
            "id": 11882,
            "profile_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png)",
            "comment": "Delayed to August 24.",
            "info_url": "[https://www.nasa.gov/blogs/spacestation/2025/08/14/head-to-toe-blood-flow-studies-on-station-are-protecting-space-crews/](https://www.nasa.gov/blogs/spacestation/2025/08/14/head-to-toe-blood-flow-studies-on-station-are-protecting-space-crews/)",
            "created_by": "Cosmic_Penguin",
            "created_on": "2025-08-15T01:17:00Z"
        },
        {
            "id": 11840,
            "profile_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png)",
            "comment": "Updated T-0 and set GO.",
            "info_url": "[https://nasa-public-data.s3.amazonaws.com/iss-coords/current/ISS_OEM/ISS.OEM_J2K_EPH.txt](https://nasa-public-data.s3.amazonaws.com/iss-coords/current/ISS_OEM/ISS.OEM_J2K_EPH.txt)",
            "created_by": "Cosmic_Penguin",
            "created_on": "2025-08-12T01:51:00Z"
        },
        {
            "id": 11724,
            "profile_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png)",
            "comment": "Tweaked T-0.",
            "info_url": "[https://www.launchphotography.com/Launch_Viewing_Guide.html](https://www.launchphotography.com/Launch_Viewing_Guide.html)",
            "created_by": "Cosmic_Penguin",
            "created_on": "2025-08-02T23:25:00Z"
        },
        {
            "id": 11627,
            "profile_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png)",
            "comment": "Updated launch time.",
            "info_url": "[https://www.launchphotography.com/Launch_Viewing_Guide.html](https://www.launchphotography.com/Launch_Viewing_Guide.html)",
            "created_by": "Cosmic_Penguin",
            "created_on": "2025-07-25T18:25:00Z"
        },
        {
            "id": 11626,
            "profile_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png)",
            "comment": "NET August 21.",
            "info_url": "[https://www.nasa.gov/news-release/nasa-invites-media-to-spacexs-33rd-resupply-launch-to-space-station/](https://www.nasa.gov/news-release/nasa-invites-media-to-spacexs-33rd-resupply-launch-to-space-station/)",
            "created_by": "Cosmic_Penguin",
            "created_on": "2025-07-25T17:55:00Z"
        },
        {
            "id": 10992,
            "profile_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png)",
            "comment": "NET late August.",
            "info_url": "[https://www.nasa.gov/blogs/commercialcrew/2025/05/14/nasa-partners-adjust-summer-2025-space-station-flight-planning/](https://www.nasa.gov/blogs/commercialcrew/2025/05/14/nasa-partners-adjust-summer-2025-space-station-flight-planning/)",
            "created_by": "Cosmic_Penguin",
            "created_on": "2025-05-14T18:59:00Z"
        },
        {
            "id": 10501,
            "profile_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png)",
            "comment": "NET Q3 2025.",
            "info_url": "[https://www.youtube.com/watch?v=XJVKM90SdKs](https://www.youtube.com/watch?v=XJVKM90SdKs)",
            "created_by": "Cosmic_Penguin",
            "created_on": "2025-03-19T06:08:00Z"
        },
        {
            "id": 10330,
            "profile_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/profile_images/cosmic2520penguin_profile_20210817212020.png)",
            "comment": "NET 2H 2025.",
            "info_url": "[https://www.youtube.com/watch?v=Xq5CH-d4IuU](https://www.youtube.com/watch?v=Xq5CH-d4IuU)",
            "created_by": "Cosmic_Penguin",
            "created_on": "2025-03-08T02:58:00Z"
        }
    ],
    "net": "2025-08-24T06:45:36Z",
    "net_precision": {
        "id": 0,
        "name": "Second",
        "abbrev": "SEC",
        "description": "The T-0 is accurate to the second."
    },
    "window_end": "2025-08-24T06:45:36Z",
    "window_start": "2025-08-24T06:45:36Z",
    "probability": 70,
    "weather_concerns": "Cumulus Cloud Rule, Lightning Rule",
    "holdreason": "",
    "failreason": "",
    "hashtag": null,
    "launch_service_provider": {
        "id": 121,
        "url": "[https://ll.thespacedevs.com/2.2.0/agencies/121/](https://ll.thespacedevs.com/2.2.0/agencies/121/)",
        "name": "SpaceX",
        "featured": true,
        "type": "Commercial",
        "country_code": "USA",
        "abbrev": "SpX",
        "description": "Space Exploration Technologies Corp., known as SpaceX, is an American aerospace manufacturer and space transport services company headquartered in Hawthorne, California. It was founded in 2002 by entrepreneur Elon Musk with the goal of reducing space transportation costs and enabling the colonization of Mars. SpaceX operates from many pads, on the East Coast of the US they operate from SLC-40 at Cape Canaveral Space Force Station and historic LC-39A at Kennedy Space Center. They also operate from SLC-4E at Vandenberg Space Force Base, California, usually for polar launches. Another launch site is being developed at Boca Chica, Texas.",
        "administrator": "CEO: Elon Musk",
        "founding_year": "2002",
        "launchers": "Falcon | Starship",
        "spacecraft": "Dragon",
        "launch_library_url": null,
        "total_launch_count": 555,
        "consecutive_successful_launches": 40,
        "successful_launches": 540,
        "failed_launches": 15,
        "pending_launches": 117,
        "consecutive_successful_landings": 40,
        "successful_landings": 501,
        "failed_landings": 27,
        "attempted_landings": 527,
        "info_url": "[https://www.spacex.com/](https://www.spacex.com/)",
        "wiki_url": "[https://en.wikipedia.org/wiki/SpaceX](https://en.wikipedia.org/wiki/SpaceX)",
        "logo_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_logo_20220826094919.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_logo_20220826094919.png)",
        "image_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_image_20190207032501.jpeg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_image_20190207032501.jpeg)",
        "nation_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_nation_20230531064544.jpg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_nation_20230531064544.jpg)"
    },
    "rocket": {
        "id": 7746,
        "configuration": {
            "id": 164,
            "url": "[https://ll.thespacedevs.com/2.2.0/config/launcher/164/](https://ll.thespacedevs.com/2.2.0/config/launcher/164/)",
            "name": "Falcon 9",
            "active": true,
            "reusable": true,
            "description": "Falcon 9 is a two-stage rocket designed and manufactured by SpaceX for the reliable and safe transport of satellites and the Dragon spacecraft into orbit. The Block 5 variant is the fifth major interval aimed at improving upon the ability for rapid reusability.",
            "family": "Falcon",
            "full_name": "Falcon 9 Block 5",
            "manufacturer": {
                "id": 121,
                "url": "[https://ll.thespacedevs.com/2.2.0/agencies/121/](https://ll.thespacedevs.com/2.2.0/agencies/121/)",
                "name": "SpaceX",
                "featured": true,
                "type": "Commercial",
                "country_code": "USA",
                "abbrev": "SpX",
                "description": "Space Exploration Technologies Corp., known as SpaceX, is an American aerospace manufacturer and space transport services company headquartered in Hawthorne, California. It was founded in 2002 by entrepreneur Elon Musk with the goal of reducing space transportation costs and enabling the colonization of Mars. SpaceX operates from many pads, on the East Coast of the US they operate from SLC-40 at Cape Canaveral Space Force Station and historic LC-39A at Kennedy Space Center. They also operate from SLC-4E at Vandenberg Space Force Base, California, usually for polar launches. Another launch site is being developed at Boca Chica, Texas.",
                "administrator": "CEO: Elon Musk",
                "founding_year": "2002",
                "launchers": "Falcon | Starship",
                "spacecraft": "Dragon",
                "launch_library_url": null,
                "total_launch_count": 555,
                "consecutive_successful_launches": 40,
                "successful_launches": 540,
                "failed_launches": 15,
                "pending_launches": 117,
                "consecutive_successful_landings": 40,
                "successful_landings": 501,
                "failed_landings": 27,
                "attempted_landings": 527,
                "info_url": "[https://www.spacex.com/](https://www.spacex.com/)",
                "wiki_url": "[https://en.wikipedia.org/wiki/SpaceX](https://en.wikipedia.org/wiki/SpaceX)",
                "logo_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_logo_20220826094919.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_logo_20220826094919.png)",
                "image_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_image_20190207032501.jpeg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_image_20190207032501.jpeg)",
                "nation_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_nation_20230531064544.jpg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_nation_20230531064544.jpg)"
            },
            "program": [
                {
                    "id": 11,
                    "url": "[https://ll.thespacedevs.com/2.2.0/program/11/](https://ll.thespacedevs.com/2.2.0/program/11/)",
                    "name": "Commercial Resupply Services",
                    "description": "Commercial Resupply Services (CRS) are a series of flights awarded by NASA for the delivery of cargo and supplies to the International Space Station.The first CRS contracts were signed in 2008 and awarded $1.6 billion to SpaceX for twelve cargo Dragon and $1.9 billion to Orbital Sciences for eight Cygnus flights, covering deliveries to 2016. The Falcon 9 and Antares rockets were also developed under the CRS program to deliver cargo spacecraft to the ISS.",
                    "agencies": [
                        {
                            "id": 44,
                            "url": "[https://ll.thespacedevs.com/2.2.0/agencies/44/](https://ll.thespacedevs.com/2.2.0/agencies/44/)",
                            "name": "National Aeronautics and Space Administration",
                            "type": "Government"
                        },
                        {
                            "id": 257,
                            "url": "[https://ll.thespacedevs.com/2.2.0/agencies/257/](https://ll.thespacedevs.com/2.2.0/agencies/257/)",
                            "name": "Northrop Grumman Space Systems",
                            "type": "Commercial"
                        },
                        {
                            "id": 1020,
                            "url": "[https://ll.thespacedevs.com/2.2.0/agencies/1020/](https://ll.thespacedevs.com/2.2.0/agencies/1020/)",
                            "name": "Sierra Nevada Corporation",
                            "type": "Commercial"
                        },
                        {
                            "id": 121,
                            "url": "[https://ll.thespacedevs.com/2.2.0/agencies/121/](https://ll.thespacedevs.com/2.2.0/agencies/121/)",
                            "name": "SpaceX",
                            "type": "Commercial"
                        }
                    ],
                    "image_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/commercial2520_program_20201129212219.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/commercial2520_program_20201129212219.png)",
                    "start_date": "2008-12-23T00:00:00Z",
                    "end_date": null,
                    "info_url": null,
                    "wiki_url": "[https://en.wikipedia.org/wiki/Commercial_Resupply_Services#Commercial_Resupply_Services](https://en.wikipedia.org/wiki/Commercial_Resupply_Services#Commercial_Resupply_Services)",
                    "mission_patches": [],
                    "type": {
                        "id": 2,
                        "name": "Human Spaceflight"
                    }
                },
                {
                    "id": 5,
                    "url": "[https://ll.thespacedevs.com/2.2.0/program/5/](https://ll.thespacedevs.com/2.2.0/program/5/)",
                    "name": "Commercial Crew Program",
                    "description": "The Commercial Crew Program (CCP) is a human spaceflight program operated by NASA, in association with American aerospace manufacturers Boeing and SpaceX. The program conducts rotations between the expeditions of the International Space Station program, transporting crews to and from the International Space Station (ISS) aboard Boeing Starliner and SpaceX Crew Dragon capsules, in the first crewed orbital spaceflights operated by private companies.",
                    "agencies": [
                        {
                            "id": 80,
                            "url": "[https://ll.thespacedevs.com/2.2.0/agencies/80/](https://ll.thespacedevs.com/2.2.0/agencies/80/)",
                            "name": "Boeing",
                            "type": "Commercial"
                        },
                        {
                            "id": 44,
                            "url": "[https://ll.thespacedevs.com/2.2.0/agencies/44/](https://ll.thespacedevs.com/2.2.0/agencies/44/)",
                            "name": "National Aeronautics and Space Administration",
                            "type": "Government"
                        },
                        {
                            "id": 121,
                            "url": "[https://ll.thespacedevs.com/2.2.0/agencies/121/](https://ll.thespacedevs.com/2.2.0/agencies/121/)",
                            "name": "SpaceX",
                            "type": "Commercial"
                        }
                    ],
                    "image_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/commercial2520_program_20200820201209.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/commercial2520_program_20200820201209.png)",
                    "start_date": "2011-04-18T00:00:00Z",
                    "end_date": null,
                    "info_url": "[https://www.nasa.gov/exploration/commercial/crew/index.html](https://www.nasa.gov/exploration/commercial/crew/index.html)",
                    "wiki_url": "[https://en.wikipedia.org/wiki/Commercial_Crew_Program](https://en.wikipedia.org/wiki/Commercial_Crew_Program)",
                    "mission_patches": [],
                    "type": {
                        "id": 2,
                        "name": "Human Spaceflight"
                    }
                }
            ],
            "variant": "Block 5",
            "alias": "",
            "min_stage": 1,
            "max_stage": 2,
            "length": 70.0,
            "diameter": 3.65,
            "maiden_flight": "2018-05-11",
            "launch_cost": "52000000",
            "launch_mass": 549,
            "leo_capacity": 22800,
            "gto_capacity": 8300,
            "to_thrust": 7607,
            "apogee": 200,
            "vehicle_range": null,
            "image_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/falcon_9_image_20230807133459.jpeg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/falcon_9_image_20230807133459.jpeg)",
            "info_url": "[https://www.spacex.com/vehicles/falcon-9/](https://www.spacex.com/vehicles/falcon-9/)",
            "wiki_url": "[https://en.wikipedia.org/wiki/Falcon_9](https://en.wikipedia.org/wiki/Falcon_9)",
            "total_launch_count": 464,
            "consecutive_successful_launches": 166,
            "successful_launches": 463,
            "failed_launches": 1,
            "pending_launches": 103,
            "attempted_landings": 456,
            "successful_landings": 451,
            "failed_landings": 5,
            "consecutive_successful_landings": 151
        },
        "launcher_stage": [
            {
                "id": 716,
                "type": "Core",
                "reused": true,
                "launcher_flight_number": 7,
                "launcher": {
                    "id": 190,
                    "url": "[https://ll.thespacedevs.com/2.2.0/launcher/190/](https://ll.thespacedevs.com/2.2.0/launcher/190/)",
                    "details": "Falcon 9 booster.",
                    "flight_proven": true,
                    "serial_number": "B1090",
                    "status": "active",
                    "image_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/b1090_at_lz-1__image_20250316065021.jpg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/b1090_at_lz-1__image_20250316065021.jpg)",
                    "successful_landings": 7,
                    "attempted_landings": 7,
                    "flights": 7,
                    "last_launch_date": "2025-08-24T06:45:36Z",
                    "first_launch_date": "2024-12-17T22:26:00Z"
                },
                "landing": {
                    "id": 1666,
                    "attempt": true,
                    "success": true,
                    "description": "The Falcon 9 first stage B1090 has landed on ASDS ASOG after its 7th flight.",
                    "downrange_distance": 300.0,
                    "location": {
                        "id": 17,
                        "name": "A Shortfall of Gravitas",
                        "abbrev": "ASOG",
                        "description": "The fourth ASDS barge, A Shortfall of Gravitas (ASOG) is currently used to recover Falcon 9 and Heavy boosters in the Altantic Ocean.",
                        "location": null,
                        "successful_landings": 120
                    },
                    "type": {
                        "id": 1,
                        "name": "Autonomous Spaceport Drone Ship",
                        "abbrev": "ASDS",
                        "description": "An autonomous spaceport drone ship (ASDS) is an ocean-going vessel derived from a deck barge, outfitted with station-keeping engines and a large landing platform. Construction of such ships was commissioned by aerospace company SpaceX to allow for recovery of rocket first-stages at sea for high-velocity missions which do not carry enough fuel to return to the launch site after lofting spacecraft onto an orbital trajectory."
                    }
                },
                "previous_flight_date": "2025-07-22T21:12:00Z",
                "turn_around_time_days": 32,
                "previous_flight": {
                    "id": "5221eb56-ccb1-498c-a757-89e34cc099d7",
                    "name": "Falcon 9 Block 5 | O3b mPower 9-10"
                }
            }
        ],
        "spacecraft_stage": {
            "id": 878,
            "url": "[https://ll.thespacedevs.com/2.2.0/spacecraft/flight/878/](https://ll.thespacedevs.com/2.2.0/spacecraft/flight/878/)",
            "mission_end": null,
            "destination": "ISS",
            "launch_crew": [],
            "onboard_crew": [],
            "landing_crew": [],
            "spacecraft": {
                "id": 554,
                "url": "[https://ll.thespacedevs.com/2.2.0/spacecraft/554/](https://ll.thespacedevs.com/2.2.0/spacecraft/554/)",
                "name": "Cargo Dragon C211",
                "serial_number": "C211",
                "is_placeholder": false,
                "in_space": false,
                "time_in_space": "P88DT7H3M3S",
                "time_docked": "P83DT20H24M",
                "flights_count": 2,
                "mission_ends_count": 2,
                "status": {
                    "id": 1,
                    "name": "Active"
                },
                "description": "Third Cargo Dragon 2",
                "spacecraft_config": {
                    "id": 7,
                    "url": "[https://ll.thespacedevs.com/2.2.0/config/spacecraft/7/](https://ll.thespacedevs.com/2.2.0/config/spacecraft/7/)",
                    "name": "Cargo Dragon 2",
                    "type": {
                        "id": 2,
                        "name": "Capsule"
                    },
                    "agency": {
                        "id": 121,
                        "url": "[https://ll.thespacedevs.com/2.2.0/agencies/121/](https://ll.thespacedevs.com/2.2.0/agencies/121/)",
                        "name": "SpaceX",
                        "featured": true,
                        "type": "Commercial",
                        "country_code": "USA",
                        "abbrev": "SpX",
                        "description": "Space Exploration Technologies Corp., known as SpaceX, is an American aerospace manufacturer and space transport services company headquartered in Hawthorne, California. It was founded in 2002 by entrepreneur Elon Musk with the goal of reducing space transportation costs and enabling the colonization of Mars. SpaceX operates from many pads, on the East Coast of the US they operate from SLC-40 at Cape Canaveral Space Force Station and historic LC-39A at Kennedy Space Center. They also operate from SLC-4E at Vandenberg Space Force Base, California, usually for polar launches. Another launch site is being developed at Boca Chica, Texas.",
                        "administrator": "CEO: Elon Musk",
                        "founding_year": "2002",
                        "launchers": "Falcon | Starship",
                        "spacecraft": "Dragon",
                        "parent": null,
                        "image_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_image_20190207032501.jpeg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_image_20190207032501.jpeg)",
                        "logo_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_logo_20220826094919.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/spacex_logo_20220826094919.png)"
                    },
                    "in_use": true,
                    "capability": "Cargo Earth Orbit Logistics",
                    "history": "Cargo Dragon 2 is an updated version of the original Dragon spaceship designed to service the International Space Station with first flights conducted in 2020.\r\n\r\nIn contrast to Dragon 1 it docks to the International Space Station instead of being berthed by the Canada Arm.",
                    "details": "Cargo Dragon 2 is a autonomous spaceship capable of bringing science to and from the International Space Station with large pressurized and un-pressurized sections to support a variety of missions.",
                    "maiden_flight": "2020-12-06",
                    "height": 7.2,
                    "diameter": 3.7,
                    "human_rated": false,
                    "crew_capacity": null,
                    "payload_capacity": 6000,
                    "payload_return_capacity": 3000,
                    "flight_life": "Able to fly for up to one week of free flight or two years docked.",
                    "image_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/crs-28_dragon_d_image_20230530191602.jpeg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/crs-28_dragon_d_image_20230530191602.jpeg)",
                    "nation_url": null,
                    "wiki_link": "[https://en.wikipedia.org/wiki/Dragon_2](https://en.wikipedia.org/wiki/Dragon_2)",
                    "info_link": "[https://www.spacex.com/dragon](https://www.spacex.com/dragon)"
                }
            },
            "landing": {
                "id": 1599,
                "attempt": true,
                "success": null,
                "description": "The Cargo Dragon spacecraft will splash down in the Pacific Ocean.",
                "downrange_distance": null,
                "location": {
                    "id": 18,
                    "name": "Pacific Ocean",
                    "abbrev": "PAC",
                    "description": "Pacific Ocean",
                    "location": null,
                    "successful_landings": 49
                },
                "type": {
                    "id": 4,
                    "name": "Parachute Landing",
                    "abbrev": "PCL",
                    "description": "Unpowered landing using parachute(s)."
                }
            },
            "docking_events": []
        }
    },
    "mission": {
        "id": 6264,
        "name": "Dragon CRS-2 SpX-33",
        "description": "33rd commercial resupply services mission to the International Space Station operated by SpaceX. The flight will be conducted under the second Commercial Resupply Services contract with NASA.\r\n\r\nCargo Dragon 2 brings supplies and payloads, including critical materials to directly support science and research investigations that occur onboard the orbiting laboratory.\r\n\r\nThe CRS SpX-33 Mission will be the first mission including a boost module inside the dragons trunk for ISS orbit raising.",
        "launch_designator": null,
        "type": "Resupply",
        "orbit": {
            "id": 8,
            "name": "Low Earth Orbit",
            "abbrev": "LEO"
        },
        "agencies": [
            {
                "id": 44,
                "url": "[https://ll.thespacedevs.com/2.2.0/agencies/44/](https://ll.thespacedevs.com/2.2.0/agencies/44/)",
                "name": "National Aeronautics and Space Administration",
                "featured": true,
                "type": "Government",
                "country_code": "USA",
                "abbrev": "NASA",
                "description": "The National Aeronautics and Space Administration is an independent agency of the executive branch of the United States federal government responsible for the civilian space program, as well as aeronautics and aerospace research. NASA have many launch facilities but most are inactive. The most commonly used pad will be LC-39B at Kennedy Space Center in Florida.",
                "administrator": "Acting Administrator:  James Free",
                "founding_year": "1958",
                "launchers": "Space Shuttle | SLS",
                "spacecraft": "Orion",
                "launch_library_url": null,
                "total_launch_count": 141,
                "consecutive_successful_launches": 11,
                "successful_launches": 121,
                "failed_launches": 20,
                "pending_launches": 6,
                "consecutive_successful_landings": 0,
                "successful_landings": 0,
                "failed_landings": 0,
                "attempted_landings": 0,
                "info_url": "[https://www.nasa.gov](https://www.nasa.gov/)",
                "wiki_url": "[https://en.wikipedia.org/wiki/National_Aeronautics_and_Space_Administration](https://en.wikipedia.org/wiki/National_Aeronautics_and_Space_Administration)",
                "logo_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/national2520aeronautics2520and2520space2520administration_logo_20190207032448.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/national2520aeronautics2520and2520space2520administration_logo_20190207032448.png)",
                "image_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/national2520aeronautics2520and2520space2520administration_image_20190207032448.jpeg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/national2520aeronautics2520and2520space2520administration_image_20190207032448.jpeg)",
                "nation_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/national2520aeronautics2520and2520space2520administration_nation_20230803040809.jpg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/national2520aeronautics2520and2520space2520administration_nation_20230803040809.jpg)"
            }
        ],
        "info_urls": [],
        "vid_urls": []
    },
    "pad": {
        "id": 80,
        "url": "[https://ll.thespacedevs.com/2.2.0/pad/80/](https://ll.thespacedevs.com/2.2.0/pad/80/)",
        "agency_id": 121,
        "name": "Space Launch Complex 40",
        "description": "",
        "info_url": null,
        "wiki_url": "[https://en.wikipedia.org/wiki/Cape_Canaveral_Air_Force_Station_Space_Launch_Complex_40](https://en.wikipedia.org/wiki/Cape_Canaveral_Air_Force_Station_Space_Launch_Complex_40)",
        "map_url": "[https://www.google.com/maps?q=28.56194122,-80.57735736](https://www.google.com/maps?q=28.56194122%2C-80.57735736)",
        "latitude": "28.56194122",
        "longitude": "-80.57735736",
        "location": {
            "id": 12,
            "url": "[https://ll.thespacedevs.com/2.2.0/location/12/](https://ll.thespacedevs.com/2.2.0/location/12/)",
            "name": "Cape Canaveral SFS, FL, USA",
            "country_code": "USA",
            "description": "Cape Canaveral Space Force Station (CCSFS) is an installation of the United States Space Force's Space Launch Delta 45, located on Cape Canaveral in Brevard County, Florida.",
            "map_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/map_images/location_12_20200803142519.jpg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/map_images/location_12_20200803142519.jpg)",
            "timezone_name": "America/New_York",
            "total_launch_count": 1047,
            "total_landing_count": 67
        },
        "country_code": "USA",
        "map_image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/map_images/pad_80_20200803143323.jpg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/map_images/pad_80_20200803143323.jpg)",
        "total_launch_count": 329,
        "orbital_launch_attempt_count": 329
    },
    "infoURLs": [
        {
            "priority": 10,
            "source": "[www.spacex.com](http://www.spacex.com/)",
            "title": "SpaceX",
            "description": "SpaceX designs, manufactures and launches advanced rockets and spacecraft. The company was founded in 2002 to revolutionize space technology, with the ultimate goal of enabling people to live on other planets.",
            "feature_image": null,
            "url": "[https://www.spacex.com/launches/crs33](https://www.spacex.com/launches/crs33)",
            "type": {
                "id": 1,
                "name": "Official Page"
            },
            "language": {
                "id": 1,
                "name": "English",
                "code": "en"
            }
        }
    ],
    "vidURLs": [
        {
            "priority": 9,
            "source": "[youtube.com](https://youtube.com/)",
            "publisher": "NASA",
            "title": "NASA's SpaceX 33rd Commercial Resupply Services Launch",
            "description": "The 33rd SpaceX commercial resupply mission to the International Space Station is set to lift off at 2:45 a.m. EDT (0645 UTC) on Sunday, Aug. 24, from Space Launch Complex 40 at Cape Canaveral Space F...",
            "feature_image": "[https://i.ytimg.com/vi/qk1JnExKcoo/maxresdefault.jpg](https://i.ytimg.com/vi/qk1JnExKcoo/maxresdefault.jpg)",
            "url": "[https://www.youtube.com/watch?v=qk1JnExKcoo](https://www.youtube.com/watch?v=qk1JnExKcoo)",
            "type": {
                "id": 1,
                "name": "Official Webcast"
            },
            "language": {
                "id": 1,
                "name": "English",
                "code": "en"
            },
            "start_time": "2025-08-24T06:24:39Z",
            "end_time": "2025-08-24T07:11:57Z"
        },
        {
            "priority": 10,
            "source": "x.com",
            "publisher": "SpaceX",
            "title": "CRS-33 Mission | Launch",
            "description": "Livestream on X",
            "feature_image": "[https://pbs.twimg.com/media/GybSKuqa0AA11BX.jpg](https://pbs.twimg.com/media/GybSKuqa0AA11BX.jpg)",
            "url": "[https://x.com/i/broadcasts/1kvJpMrXLraxE](https://x.com/i/broadcasts/1kvJpMrXLraxE)",
            "type": {
                "id": 1,
                "name": "Official Webcast"
            },
            "language": {
                "id": 1,
                "name": "English",
                "code": "en"
            },
            "start_time": "2025-08-24T06:22:55Z",
            "end_time": "2025-08-24T07:11:08Z"
        },
        {
            "priority": 11,
            "source": "[plus.nasa.gov](http://plus.nasa.gov/)",
            "publisher": "NASA",
            "title": "NASA’s SpaceX 33rd Commercial Resupply Services Launch",
            "description": "",
            "feature_image": "[https://plus.nasa.gov/wp-content/uploads/2025/08/crs-33-night-launch-key-art-r1-horizontal-program-tile-16-9-without-title.jpg](https://plus.nasa.gov/wp-content/uploads/2025/08/crs-33-night-launch-key-art-r1-horizontal-program-tile-16-9-without-title.jpg)",
            "url": "[https://plus.nasa.gov/scheduled-video/nasas-spacex-33rd-commercial-resupply-services-launch/](https://plus.nasa.gov/scheduled-video/nasas-spacex-33rd-commercial-resupply-services-launch/)",
            "type": {
                "id": 1,
                "name": "Official Webcast"
            },
            "language": {
                "id": 1,
                "name": "English",
                "code": "en"
            },
            "start_time": "2025-08-24T06:25:00Z",
            "end_time": "2025-08-24T07:14:00Z"
        },
        {
            "priority": 12,
            "source": "[youtube.com](https://youtube.com/)",
            "publisher": "Spaceflight Now",
            "title": "Live: SpaceX Falcon 9 launches NASA cargo mission to boost space station",
            "description": "Watch live coverage as SpaceX launches a Falcon 9 rocket with a Cargo Dragon on a space station resupply mission for NASA. Liftoff from pad 40 at Cape Canaveral Space Force Station is scheduled for Su...",
            "feature_image": "[https://i.ytimg.com/vi/ArxZgP_tWtY/maxresdefault.jpg](https://i.ytimg.com/vi/ArxZgP_tWtY/maxresdefault.jpg)",
            "url": "[https://www.youtube.com/watch?v=ArxZgP_tWtY](https://www.youtube.com/watch?v=ArxZgP_tWtY)",
            "type": {
                "id": 3,
                "name": "Unofficial Webcast"
            },
            "language": {
                "id": 1,
                "name": "English",
                "code": "en"
            },
            "start_time": "2025-08-24T05:45:35Z",
            "end_time": "2025-08-24T07:18:03Z"
        },
        {
            "priority": 13,
            "source": "[youtube.com](https://youtube.com/)",
            "publisher": "NASA",
            "title": "NASA's SpaceX 33rd Commercial Resupply Services Launch",
            "description": "The 33rd SpaceX commercial resupply mission to the International Space Station is set to lift off at 2:45 a.m. EDT (0645 UTC) on Sunday, Aug. 24, from Space Launch Complex 40 at Cape Canaveral Space F...",
            "feature_image": "[https://i.ytimg.com/vi/qk1JnExKcoo/maxresdefault.jpg](https://i.ytimg.com/vi/qk1JnExKcoo/maxresdefault.jpg)",
            "url": "[https://www.youtube.com/watch?v=qk1JnExKcoo](https://www.youtube.com/watch?v=qk1JnExKcoo)",
            "type": {
                "id": 3,
                "name": "Unofficial Webcast"
            },
            "language": {
                "id": 1,
                "name": "English",
                "code": "en"
            },
            "start_time": "2025-08-24T06:24:39Z",
            "end_time": "2025-08-24T07:11:57Z"
        }
    ],
    "webcast_live": false,
    "timeline": [
        {
            "type": {
                "id": 1,
                "abbrev": "GO for Prop Load",
                "description": "Launch director verifies go for propellant load"
            },
            "relative_time": "-PT38M"
        },
        {
            "type": {
                "id": 2,
                "abbrev": "Prop Load",
                "description": "Start of propelland loading"
            },
            "relative_time": "-PT35M"
        },
        {
            "type": {
                "id": 3,
                "abbrev": "Stage 1 LOX Load",
                "description": "Start of liquid oxygen loading in the first stage"
            },
            "relative_time": "-PT35M"
        },
        {
            "type": {
                "id": 4,
                "abbrev": "Stage 2 LOX Load",
                "description": "Start of liquid oxygen loading in the second stage"
            },
            "relative_time": "-PT16M"
        },
        {
            "type": {
                "id": 5,
                "abbrev": "Engine Chill",
                "description": "Start of engine chilling"
            },
            "relative_time": "-PT7M"
        },
        {
            "type": {
                "id": 38,
                "abbrev": "Dragon Internal Power",
                "description": "Dragon transitions to internal power"
            },
            "relative_time": "-PT5M"
        },
        {
            "type": {
                "id": 6,
                "abbrev": "Startup",
                "description": "The onboard computer takes control over the countdown and runs last checks"
            },
            "relative_time": "-PT1M"
        },
        {
            "type": {
                "id": 7,
                "abbrev": "Tank Press",
                "description": "Fuel tanks are pressurized to flight levels"
            },
            "relative_time": "-PT1M"
        },
        {
            "type": {
                "id": 8,
                "abbrev": "GO for Launch",
                "description": "Launch director verifies go for launch"
            },
            "relative_time": "-PT45S"
        },
        {
            "type": {
                "id": 9,
                "abbrev": "Ignition",
                "description": "Start of the engine ignition sequence"
            },
            "relative_time": "-PT3S"
        },
        {
            "type": {
                "id": 10,
                "abbrev": "Liftoff",
                "description": "First upwards movement of the rocket"
            },
            "relative_time": "P0D"
        },
        {
            "type": {
                "id": 11,
                "abbrev": "Max-Q",
                "description": "Maximum dynamic pressure"
            },
            "relative_time": "PT1M12S"
        },
        {
            "type": {
                "id": 12,
                "abbrev": "MECO",
                "description": "Cut-off of the main engine"
            },
            "relative_time": "PT2M27S"
        },
        {
            "type": {
                "id": 13,
                "abbrev": "Stage 2 Separation",
                "description": "Separation of the second stage from the first"
            },
            "relative_time": "PT2M30S"
        },
        {
            "type": {
                "id": 14,
                "abbrev": "SES-1",
                "description": "First start of the second engine"
            },
            "relative_time": "PT2M38S"
        },
        {
            "type": {
                "id": 16,
                "abbrev": "Entry Burn Startup",
                "description": "Start of the atmospheric entry burn"
            },
            "relative_time": "PT6M32S"
        },
        {
            "type": {
                "id": 17,
                "abbrev": "Entry Burn Shutdown",
                "description": "End of the atmospheric entry burn"
            },
            "relative_time": "PT6M59S"
        },
        {
            "type": {
                "id": 18,
                "abbrev": "Stage 1 Landing Burn",
                "description": "Start of the first stage landing burn"
            },
            "relative_time": "PT8M16S"
        },
        {
            "type": {
                "id": 19,
                "abbrev": "Stage 1 Landing",
                "description": "Landing of the first stage"
            },
            "relative_time": "PT8M41S"
        },
        {
            "type": {
                "id": 20,
                "abbrev": "SECO-1",
                "description": "First cut-off of the second engine"
            },
            "relative_time": "PT8M47S"
        },
        {
            "type": {
                "id": 41,
                "abbrev": "Dragon Separation",
                "description": "Dragon separates from the second stage"
            },
            "relative_time": "PT9M45S"
        },
        {
            "type": {
                "id": 42,
                "abbrev": "Dragon Nosecode Open",
                "description": "Start of the opening sequence of Dragon's nosecone"
            },
            "relative_time": "PT10M33S"
        }
    ],
    "image": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/falcon2520925_image_20210520085648.jpeg](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/falcon2520925_image_20210520085648.jpeg)",
    "infographic": null,
    "program": [
        {
            "id": 11,
            "url": "[https://ll.thespacedevs.com/2.2.0/program/11/](https://ll.thespacedevs.com/2.2.0/program/11/)",
            "name": "Commercial Resupply Services",
            "description": "Commercial Resupply Services (CRS) are a series of flights awarded by NASA for the delivery of cargo and supplies to the International Space Station.The first CRS contracts were signed in 2008 and awarded $1.6 billion to SpaceX for twelve cargo Dragon and $1.9 billion to Orbital Sciences for eight Cygnus flights, covering deliveries to 2016. The Falcon 9 and Antares rockets were also developed under the CRS program to deliver cargo spacecraft to the ISS.",
            "agencies": [
                {
                    "id": 44,
                    "url": "[https://ll.thespacedevs.com/2.2.0/agencies/44/](https://ll.thespacedevs.com/2.2.0/agencies/44/)",
                    "name": "National Aeronautics and Space Administration",
                    "type": "Government"
                },
                {
                    "id": 257,
                    "url": "[https://ll.thespacedevs.com/2.2.0/agencies/257/](https://ll.thespacedevs.com/2.2.0/agencies/257/)",
                    "name": "Northrop Grumman Space Systems",
                    "type": "Commercial"
                },
                {
                    "id": 1020,
                    "url": "[https://ll.thespacedevs.com/2.2.0/agencies/1020/](https://ll.thespacedevs.com/2.2.0/agencies/1020/)",
                    "name": "Sierra Nevada Corporation",
                    "type": "Commercial"
                },
                {
                    "id": 121,
                    "url": "[https://ll.thespacedevs.com/2.2.0/agencies/121/](https://ll.thespacedevs.com/2.2.0/agencies/121/)",
                    "name": "SpaceX",
                    "type": "Commercial"
                }
            ],
            "image_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/commercial2520_program_20201129212219.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/commercial2520_program_20201129212219.png)",
            "start_date": "2008-12-23T00:00:00Z",
            "end_date": null,
            "info_url": null,
            "wiki_url": "[https://en.wikipedia.org/wiki/Commercial_Resupply_Services#Commercial_Resupply_Services](https://en.wikipedia.org/wiki/Commercial_Resupply_Services#Commercial_Resupply_Services)",
            "mission_patches": [],
            "type": {
                "id": 2,
                "name": "Human Spaceflight"
            }
        },
        {
            "id": 17,
            "url": "[https://ll.thespacedevs.com/2.2.0/program/17/](https://ll.thespacedevs.com/2.2.0/program/17/)",
            "name": "International Space Station",
            "description": "The International Space Station programme is tied together by a complex set of legal, political and financial agreements between the sixteen nations involved in the project, governing ownership of the various components, rights to crewing and utilization, and responsibilities for crew rotation and resupply of the International Space Station. It was conceived in 1984 by President Ronald Reagan, during the Space Station Freedom project as it was originally called.",
            "agencies": [
                {
                    "id": 16,
                    "url": "[https://ll.thespacedevs.com/2.2.0/agencies/16/](https://ll.thespacedevs.com/2.2.0/agencies/16/)",
                    "name": "Canadian Space Agency",
                    "type": "Government"
                },
                {
                    "id": 27,
                    "url": "[https://ll.thespacedevs.com/2.2.0/agencies/27/](https://ll.thespacedevs.com/2.2.0/agencies/27/)",
                    "name": "European Space Agency",
                    "type": "Multinational"
                },
                {
                    "id": 37,
                    "url": "[https://ll.thespacedevs.com/2.2.0/agencies/37/](https://ll.thespacedevs.com/2.2.0/agencies/37/)",
                    "name": "Japan Aerospace Exploration Agency",
                    "type": "Government"
                },
                {
                    "id": 44,
                    "url": "[https://ll.thespacedevs.com/2.2.0/agencies/44/](https://ll.thespacedevs.com/2.2.0/agencies/44/)",
                    "name": "National Aeronautics and Space Administration",
                    "type": "Government"
                },
                {
                    "id": 63,
                    "url": "[https://ll.thespacedevs.com/2.2.0/agencies/63/](https://ll.thespacedevs.com/2.2.0/agencies/63/)",
                    "name": "Russian Federal Space Agency (ROSCOSMOS)",
                    "type": "Government"
                }
            ],
            "image_url": "[https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/international2_program_20201129184745.png](https://thespacedevs-prod.nyc3.digitaloceanspaces.com/media/images/international2_program_20201129184745.png)",
            "start_date": "1998-11-20T06:40:00Z",
            "end_date": null,
            "info_url": "[https://www.nasa.gov/mission_pages/station/main/index.html](https://www.nasa.gov/mission_pages/station/main/index.html)",
            "wiki_url": "[https://en.wikipedia.org/wiki/International_Space_Station_programme](https://en.wikipedia.org/wiki/International_Space_Station_programme)",
            "mission_patches": [],
            "type": {
                "id": 2,
                "name": "Human Spaceflight"
            }
        }
    ],
    "orbital_launch_attempt_count": 7041,
    "location_launch_attempt_count": 1047,
    "pad_launch_attempt_count": 329,
    "agency_launch_attempt_count": 555,
    "orbital_launch_attempt_count_year": 192,
    "location_launch_attempt_count_year": 53,
    "pad_launch_attempt_count_year": 49,
    "agency_launch_attempt_count_year": 106,
    "pad_turnaround": "P9DT18H16M6S",
    "mission_patches": [],
    "type": "detailed"
}
```