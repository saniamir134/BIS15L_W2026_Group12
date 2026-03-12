# Data and code from: You shall not pass; the Pacific oxygen minimum zone creates a boundary to shortfin mako shark distribution in the Eastern North Pacific Ocean

[https://doi.org/10.5061/dryad.2rbnzs7vm](https://doi.org/10.5061/dryad.2rbnzs7vm)

Satellite tracking data for mako sharks in the Eastern North Pacific and Western North Atlantic Oceans, as well as environmental data and R code for simulating tracks.

## Description of the data and file structure

AtlanticArgos.csv; Raw Argos data for mako sharks in the Atlantic, with columns:

id = track id

date = date and time (UTC) of Argos detections

lc = Argos location class (3,2,1,0,A,B)

lon = longitude

lat = latitude

PacificArgos.csv; Raw Argos data for mako sharks in the Pacific, with columns:

id = track id

date = date and time (UTC) of Argos detections

lc = Argos location class (3,2,1,0,A,B)

lon = longitude

lat = latitude

Track_Simulation_Analysis_Code.R = R code for simulating tracks and recreating the analysis of avoidance of the Pacific OMZ

Mako_DATA.RData = an R workspace containing data objects including:

12 Monthly Raster Brick objects with SST, Ocean Heat Content, and Dissolved O2 at 100m (JanR, FebR, etc.)

Atl.SSM = Data frame of daily SSM location estimates for Atlantic Sharks

Pacific.SSM = Data frame of daily SSM location estimates for Pacific Sharks

Atl.samples = Data frame of 100 random daily MCMC samples from SSM locations for Atlantic sharks

PacFemale.samples = Data frame of 100 random daily MCMC samples from SSM locations for female Pacific sharks

PacMale.samples = Data frame of 100 random daily MCMC samples from SSM locations for male Pacific sharks

Simulation.Data = Data frame of daily locations and habitat variables for simulated tracks

simulation.summary = Data frame of summarized count of days over the Pacific OMZ for real and simulated tracks

Pacific_TAD.csv; Time at depth data for make sharks in the Pacific during days with SLRT and PAT available. Columns include:

id = shark id

PAT_PTT = PAT tag id

spot_tt = SLRT id

Date = Date

B_50 = proportion of time between 0 - 50m

B100 = proportion of time >50 - 100m

B150 = proportion of time >100 - 150m

B200 = proportion of time >150 - 200m

B_200 = proportion of time > 200m

lon = longitude

lat = latitude

SST = sea surface temperature (Celsius)

DO_depth = Hypoxic boundary depth (m), where dissolved oxygen concentration is 3.0 ml/l

## Code/Software

All analyses were run in R v4.2.2