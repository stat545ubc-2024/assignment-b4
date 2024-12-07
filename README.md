# Vancouver Trees App

## Link to Running Shiny App
You can access the live version of the app at the following link:   https://linoja.shinyapps.io/vancouvertrees_app/

## Description of the App
This Shiny app allows users to explore and analyze data on street trees in Vancouver. It provides a user-friendly interface with interactive features to help users understand the distribution, species, and other details of the urban tree population in the city.

### Key Features:
1. **Home Page**:
   - A welcoming landing page with rotating tree images changing every 5 seconds for user engagement.
   - Navigation tabs to explore other pages in the app.
   - Footer with copyright details.

2. **Table Page**:
   - Interactive data table allowing users to filter tree data by neighborhood, species, and planting year.
   - Option to download filtered data as a CSV file.
   - Pagination to display data in sets of 10 rows for easy navigation.

3. **Tree Map Page**:
   - Displays an image of Vancouver showcasing the tree population distribution.  
   - Provides an overview of tree density across different neighborhoods.

4. **Plot Page**:
   - Interactive plots showing tree counts by species based on user-selected neighborhood and year.
   - Features for zooming and downloading plots as PNG files.

5. **About Page**:
   - Includes contact information for the app creator.
   - A feedback form where users can submit their name, email, and comments.  
   - Submit button shows a "Message Sent Successfully" confirmation upon completion.

### Purpose:
This app serves as a tool for urban planners, environmentalists, and citizens to understand and analyze Vancouver's urban tree population. It provides insights into tree distribution, density, and species variety, promoting awareness of urban forestry.

## Dataset Source
The dataset used in this app comes from publicly available information on Vancouver's street trees. You can find additional details on the dataset at the City of Vancouver's Open Data Portal:  
[City of Vancouver Open Data Portal](https://opendata.vancouver.ca/explore/dataset/street-trees/information/)

## Data Access and Licensing
The dataset used in this app is available for public use and can be accessed via the City of Vancouver's Open Data Portal. Please refer to the terms and conditions of the dataset for appropriate usage.

## Installation Instructions
To run this app locally, follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/vancouver-trees-app.git
   ```

2. Install the required R packages:

   ```R
   install.packages(c("shiny", "ggplot2", "dplyr", "DT", "shinythemes", "rsconnect"))
   ```

3. Open the app in RStudio:
   - Navigate to the folder containing the app files.
   - Run the app using:

     ```R
     shiny::runApp()
     ```


## Folder Structure
- **www**: Contains static files like images used in the app (e.g., Vancouver tree map image).  
- **app.R**: Main R script containing both the UI and server logic of the app.


## Feedback
If you encounter any issues or have suggestions to improve the app, please feel free to provide feedback using the form available on the **About** page. You can also reach out directly through the contact details provided in the app.

