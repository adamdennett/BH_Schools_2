
##################################
###None of this seems to work very well

# Create the dataframe
data <- data.frame(
  Year_of_secondary_entry = 2024:2034,
  PACA_catchment = c(220, 220, 220, 220, 220, 220, 220, 220, 220, 220, 220),
  PACA_reduced_by = c(115, 114, 113, 112, 111, 110, 109, 108, 107, 106, 105),
  PACA_adjusted_for_CN_4_kings = c(151, 150, 149, 148, 147, 146, 145, 144, 143, 142, 141),
  PACA_number_of_FSM_eligible_pupils = c(18, 25, 25, 27, 27, 27, 27, 27, 27, 27, 27),
  PACA_difference_in_pupil_numbers_from_Oct_2022_forecast = c(6, 5, 4, 3, 2, 1, -2, -2, -2, -2, -2),
  PACA_difference_in_final_forecast_numbers_from_Oct_2022_forecast = c(6, 5, 4, 3, 2, 1, -2, -2, -2, -2, -2),
  Hove_Park_Blatch_catchment = c(510, 509, 508, 507, 506, 505, 504, 503, 502, 501, 500),
  Hove_Park_Blatch_reduced_by = c(640, 639, 638, 637, 636, 635, 634, 633, 632, 631, 630),
  Hove_Park_Blatch_adjusted_for_CN_4_kings = c(730, 729, 728, 727, 726, 725, 724, 723, 722, 721, 720),
  Hove_Park_Blatch_number_of_FSM_eligible_pupils = c(10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10),
  Hove_Park_Blatch_difference_in_pupil_numbers_from_Oct_2022_forecast = c(-16, 10, 64, 11, -5, -18, 2, 48, 48, 48, 48),
  Stringer_Vardean_catchment = c(630, 629, 628, 627, 626, 625, 624, 623, 622, 621, 620),
  Stringer_Vardean_adjusted_for_CN_4_kings = c(640, 639, 638, 637, 636, 635, 634, 633, 632, 631, 630),
  Stringer_Vardean_number_of_FSM_eligible_pupils = c(11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11),
  Longhill_catchment = c(270, 269, 268, 267, 266, 265, 264, 263, 262, 261, 260),
  Longhill_adjusted_for_CN_4_kings = c(280, 279, 278, 277, 276, 275, 274, 273, 272, 271, 270),
  Longhill_number_of_FSM_eligible_pupils = c(27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27),
  Longhill_difference_in_pupil_numbers_from_Oct_2022_forecast = c(6, 5, 4, 3, 2, 1, -2, -2, -2, -2, -2),
  Final_forecast_difference = c(3, 2, 1, 0, -1, -2, -3, 0, 0, 0, 0)
)

# Print the dataframe
print(data)



# Create the dataframe
data_from_image <- data.frame(
  Year_of_secondary_entry = 2024:2034,
  GP_data_plus_10_percent = c(204, 203, 201, 203, 200, 204, 204, 203, 203, 204, 204),
  school_census_Oct_23 = c(203, 201, 200, 201, 200, 203, 203, 202, 202, 203, 203),
  Estimated_number_going_to_CN = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3),
  Number_attending_Kings = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
  total_overs = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
  PACA_catchment_reduced_by_1.96 = c(220, 150, 167, 177, 263, 230, 220, 235, 235, 235, 235),
  adjusted_for_CNA_Kings = c(115, 124, 134, 218, 155, 148, 148, 148, 148, 148, 148),
  FSM_eligible_pupils = c(40, 48, 55, 59, 62, 70, 69, 73, 71, 71, 71),
  Percent_FSM_eligible_pupils = c("18%", "25%", "25%", "27%", "27%", "29%", "29%", "29%", "30%", "30%", "26%"),
  difference_in_pupil_numbers_from_Oct_22_forecast = c(6, 6, 6, 39, 15, -8, 1, 1, 1, 3, 3),
  difference_in_final_forecast_numbers_from_Oct_22_forecast = c(6, 6, 6, 39, 15, -8, 1, 1, 1, 3, -2)
)

# Print the dataframe
print(data_from_image)


# Creating the dataframe with additional data columns based on the provided image
data_from_image <- data.frame(
  Year = c(2024:2030, "Total/Average"),
  Places_Available = c(220, 220, 220, 220, 220, 220, 220, 1540),
  PACA_Catchment = c(NA, NA, NA, NA, NA, NA, NA, NA),
  Reduced_by_1.96 = c(115, 114, 113, 112, 111, 110, 109, 784),
  Adjusted_for_CN_Kings = c(151, 150, 149, 148, 147, 146, 145, 1036),
  FSM_Eligible_Pupils = c("18%", "25%", "25%", "27%", "27%", "27%", "27%", "26%"),
  Difference_from_Oct_2022_Forecast = c(6, 5, 4, 3, 2, 1, -2, 15),
  Final_Forecast_Difference = c(6, 5, 4, 3, 2, 1, -2, 15),
  Hove_Park_Blatch_Catchment = c(NA, NA, NA, NA, NA, NA, NA, NA),
  Reduced_by_1.04 = c(510, 509, 508, 507, 506, 505, 504, 3549),
  Adjusted_for_CN_Kings_2 = c(640, 639, 638, 637, 636, 635, 634, 4459),
  FSM_Eligible_Pupils_2 = c("10%", "10%", "10%", "10%", "10%", "10%", "10%", "10%"),
  Difference_from_Oct_2022_Forecast_2 = c(-16, 10, 64, 11, -5, -18, 2, 48),
  Final_Forecast_Difference_2 = c(-16, 10, 64, 11, -5, -18, 2, 48),
  Stringer_Varndean_Catchment = c(NA, NA, NA, NA, NA, NA, NA, NA),
  Reduced_by_2.71 = c(630, 629, 628, 627, 626, 625, 624, 4379),
  Adjusted_for_CN_Kings_3 = c(557, 556, 555, 554, 553, 552, 551, 3878),
  FSM_Eligible_Pupils_3 = c("11%", "11%", "11%", "11%", "11%", "11%", "11%", "11%"),
  Difference_from_Oct_2022_Forecast_3 = c(3, 2, 1, 0, -1, -2, -3, 0),
  Final_Forecast_Difference_3 = c(3, 2, 1, 0, -1, -2, -3, 0),
  Longhill_Catchment = c(NA, NA, NA, NA, NA, NA, NA, NA),
  Reduced_by_2.04 = c(270, 269, 268, 267, 266, 265, 264, 1869),
  Adjusted_for_CN_Kings_4 = c(204, 203, 202, 201, 200, 199, 198, 1407),
  FSM_Eligible_Pupils_4 = c("27%", "27%", "27%", "27%", "27%", "27%", "27%", "27%"),
  Difference_from_Oct_2022_Forecast_4 = c(6, 5, 4, 3, 2, 1, -2, 15),
  Final_Forecast_Difference_4 = c(6, 5, 4, 3, 2, 1, -2, 15)
)

# Print the dataframe
print(data_from_image)

# Writing the dataframe to the "data" folder
write_xlsx(data_from_image, here::here("data", "data_from_image.xlsx"))

# Now your file "data_from_image.xlsx" is saved in the "data" folder


# Creating the dataframe
data <- data.frame(
  Year = c(2024:2034),
  ONS_SNPP_Age_11 = c(2915, 2734, 2815, 2786, 2672, 2545, 2574, 2580, 2559, 2544, 2550),
  BTN_All_Schools = c(2256, 2279, 2270, 2231, 2217, 2114, 2011, 2001, 1852, 1827, 1672),
  ONS_BTN_Difference = c(659, 455, 545, 555, 455, 431, 563, 579, 707, 717, 878),
  ONS_SNPP_Age_11_2024_Change = c(0.94, 0.97, 0.96, 0.92, 0.87, 0.88, 0.89, 0.88, 0.87, 0.87, 0.00),
  BTN_All_Schools_2024_Change = c(1.01, 1.01, 0.99, 0.98, 0.94, 0.89, 0.89, 0.82, 0.81, 0.74, 0.00),
  BTN_ONS_Rate = c(2256, 2116, 2347, 2247, 2140, 2112, 2138, 2016, 1985, 1841, 1831)
)

# Saving the dataframe as an Excel file
here()
#write_xlsx(data_from_image, here("data", "data_from_image.xlsx"))

# Now you can download the file "data_from_image.xlsx"
