# Load necessary libraries
library(shiny)
library(datateachr)  # Contains the vancouver_trees dataset
library(DT)           # For rendering tables
library(lubridate)    # For date manipulation
library(plotly)       # For interactive plots

# Load the dataset
data("vancouver_trees")

# Ensure the 'date_planted' column is in Date format and create the 'year' column
vancouver_trees$date_planted <- as.Date(vancouver_trees$date_planted, format = "%Y-%m-%d")  # Adjust format if necessary
vancouver_trees$year <- year(vancouver_trees$date_planted)
vancouver_trees <- na.omit(vancouver_trees)

# Define UI
ui <- navbarPage(
  "Vancouver Trees App",  # App title
  
  # Add custom CSS to style the page
  tags$head(
    tags$style(HTML("
      body {
        background-color: #90EE90; /* Light Green Background */
        color: black; /* Black text */
      }
      .navbar {
        background-color: #32CD32; /* Dark Green navbar */
      }
      .navbar a {
        color: white; /* White text in navbar */
      }
      .navbar a:hover {
        background-color: #4CAF50; /* Button hover color */
      }
      img {
        display: block;
        margin: auto;
        max-width: 100%;
        height: auto; /* Maintain aspect ratio */
      }
      #footer {
        text-align: center;
        margin-top: 20px;
        font-size: 14px;
        color: black; /* Black for footer text */
      }
      .feedback-section {
        display: flex;
        justify-content: space-between;
        margin-top: 20px;
      }
      .feedback-section div {
        width: 48%;
      }
    "))
  ),
  
  # Home Page
  tabPanel(
    "Home",
    fluidPage(
      # Add custom JavaScript for rotating images
      tags$head(
        tags$script(HTML("
          let images = ['tree1.jpg', 'tree2.jpg', 'tree3.jpg', 'tree4.jpg'];
          let index = 0;

          function changeImage() {
            index = (index + 1) % images.length;
            document.getElementById('treeImage').src = images[index];
          }

          setInterval(changeImage, 5000); // Change image every 5 seconds
        "))
      ),
      
      titlePanel("Welcome to Vancouver Trees App"),
      fluidRow(
        column(
          12,
          # Add an image element with an ID for JavaScript to modify
          img(
            id = "treeImage",
            src = "tree1.jpg",  # Initial image
            height = "300px",
            width = "100%"
          )
        ),
        column(12, h3("Explore Vancouver's Urban Forest!")),
        column(12, p("This app provides insights into Vancouver's urban tree population. 
                      Navigate through the tabs to explore data, visualize graphs, and learn more!"))
      ),
      
      # Footer with copyright
      div(id = "footer", "© 2024 Vancouver Trees App - Created by Linoja Sajanthan")
    )
  ),
  
  # Table Page with additional filters
  tabPanel(
    "Table",
    fluidPage(
      titlePanel("Tree Data Table"),
      sidebarLayout(
        sidebarPanel(
          
          # Filter by Tree Species
          selectInput(
            "species_filter",
            "Filter by Tree Species:",
            choices = c("All", unique(vancouver_trees$common_name)),
            selected = "All"
          ),
          
          # Filter by Neighbourhood Name
          selectInput(
            "neighbourhood_filter",
            "Filter by Neighbourhood Name:",
            choices = c("All", unique(vancouver_trees$neighbourhood_name)),
            selected = "All"
          ),
          
          # Filter by Year
          selectInput(
            "year_filter",
            "Filter by Year:",
            choices = c("All", sort(unique(vancouver_trees$year))),
            selected = "All"
          ),
          
          # Add a Download Button
          downloadButton("download_data", "Download Data as CSV")
        ),
        
        mainPanel(
          DT::DTOutput("tree_table")
        )
      )
    )
  ),
 
  # Tree map page 
  tabPanel(
    "Tree Map",
    fluidPage(
      titlePanel("Vancouver Tree Map"),
      fluidRow(
        column(12, 
               p("This map provides an overview of the tree population in Vancouver, showcasing the distribution and variety of trees across the city. The map serves as a valuable tool for urban planning and environmental analysis.")
        )
      ),  
      fluidRow(
        column(12, 
               img(id = "tree_map_image", src = "city-of-vancouver-tree-map.png", height = "600px", width = "100%"))
      )  # 
    )  # 
  ), 
  

  # Plots Page with interactive bar chart
  tabPanel(
    "Plots",
    fluidPage(
      titlePanel("Tree Species Count by Neighbourhood and Year"),
      sidebarLayout(
        sidebarPanel(
          
          # Filter by Neighbourhood Name
          selectInput(
            "plot_neighbourhood_filter",
            "Select Neighbourhood:",
            choices = c("All", unique(vancouver_trees$neighbourhood_name)),
            selected = "All"
          ),
          
          # Filter by Year
          selectInput(
            "plot_year_filter",
            "Select Year:",
            choices = c("All", sort(unique(vancouver_trees$year))),
            selected = "All"
          )
        ),
        
        mainPanel(
          plotlyOutput("species_bar_chart")
        )
      )
    )
  ),
  
  # About Page
  tabPanel(
    "About",
    fluidPage(
      titlePanel("About the App"),
      # Two-column layout for contact details and feedback form
      fluidRow(
        column(6, 
               h3("Contact Details"),
               p("This app helps to explore the details of the Vancouver's urban tree population."),
               p("Email: lino.sajanthan@gmail.com"),
               p("Phone: 123-456 7890"),
               p("Location: Vancouver, BC"),
               
               # Add image below contact details
               img(src = "tree5.jpg", height = "200px", width = "50%")  # Adjust the image path and size as needed
        ),
        
        column(6, 
               h3("Feed back"),
               p("Your questions, suggestions and comments are always welcome. Please feel free to write to us below. You will get a response withing 2-3 business days"),
               textInput("first_name", "First Name:"),
               textInput("last_name", "Last Name:"),
               textInput("email", "Email:"),
               textAreaInput("comments", "Comments:", ""),
               actionButton("submit_button", "Submit"),
               textOutput("success_message")  # To display success or error message
        )
      )
    )
  )
)

# Define Server Logic
server <- function(input, output, session) {
  # Create the year column by extracting year from date_planted
  vancouver_trees$year <- as.numeric(format(as.Date(vancouver_trees$date_planted), "%Y"))
  
  # Table Page Logic 
  output$tree_table <- DT::renderDT({
    # Apply filters based on input from user
    data <- vancouver_trees
    
    # Filter by Tree Species
    if (input$species_filter != "All") {
      data <- data[data$common_name == input$species_filter, ]
    }
    
    # Filter by Neighbourhood Name
    if (input$neighbourhood_filter != "All") {
      data <- data[data$neighbourhood_name == input$neighbourhood_filter, ]
    }
    
    # Filter by Year
    if (input$year_filter != "All") {
      data <- data[data$year == input$year_filter, ]
    }
    
    # Render the data table
    DT::datatable(data, options = list(pageLength = 10, scrollX = TRUE))
  })
  
  # Download Handler for CSV
  output$download_data <- downloadHandler(
    filename = function() {
      paste("vancouver_trees_data_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      # Get filtered data
      data <- vancouver_trees
      
      # Apply filters to the data before download
      if (input$species_filter != "All") {
        data <- data[data$common_name == input$species_filter, ]
      }
      
      if (input$neighbourhood_filter != "All") {
        data <- data[data$neighbourhood_name == input$neighbourhood_filter, ]
      }
      
      if (input$year_filter != "All") {
        data <- data[data$year == input$year_filter, ]
      }
      
      # Write the filtered data to the CSV file
      write.csv(data, file, row.names = FALSE)
    }
  )
  
  # Plot Page Logic - Interactive Bar Chart
  output$species_bar_chart <- renderPlotly({
    # Filter the data based on selected neighbourhood and year
    data <- vancouver_trees
    
    if (input$plot_neighbourhood_filter != "All") {
      data <- data[data$neighbourhood_name == input$plot_neighbourhood_filter, ]
    }
    
    if (input$plot_year_filter != "All") {
      data <- data[data$year == input$plot_year_filter, ]
    }
    
    # Count the number of trees per species
    species_count <- table(data$common_name)
    
    # Create an interactive bar chart using plotly
    plot_ly(
      x = names(species_count), 
      y = as.vector(species_count), 
      type = 'bar',
      marker = list(color = 'rgba(50, 171, 96, 0.6)', line = list(color = 'rgba(50, 171, 96, 1)', width = 2)),
      name = "Tree Species Count"
    ) %>%
      layout(
        title = paste("Number of Trees per Species in", input$plot_neighbourhood_filter, "for the Year", input$plot_year_filter),
        xaxis = list(title = "Tree Species"),
        yaxis = list(title = "Count of Trees"),
        showlegend = FALSE
      )
  })
  
  # Feedback Form Logic
  observeEvent(input$submit_button, {
    # Check if all fields are filled
    if (input$first_name != "" && input$last_name != "" && input$email != "" && input$comments != "") {
      
      # Show success message
      output$success_message <- renderText({
        "Your submission was successful!"
      })
      
      # Clear the input fields
      updateTextInput(session, "first_name", value = "")
      updateTextInput(session, "last_name", value = "")
      updateTextInput(session, "email", value = "")
      updateTextAreaInput(session, "comments", value = "")
      
    } else {
      # Show error message if any field is empty
      output$success_message <- renderText({
        "Please fill in all the fields before submitting."
      })
    }
  })
}

shinyApp(ui = ui, server = server)


# This app is created for Assignment B4 and provides detailed information about Vancouver's street tree data. The following explains the features across the app:

# 1. **Home Page**:
#    - Contains navigation tabs to other pages and displays a welcome message.
#    - Features rotating tree pictures that change every 5 seconds to attract users' attention.
#    - Includes a footer with copyright details.

# 2. **Table Page**:
#    - Provides an interactive table where users can filter tree details based on preferred neighborhood, species, and planting year.
#    - Users can view filtered data in sets of 10 entries per page, with navigation to the next set of data.
#    - The filtered data can be downloaded as a CSV file.

# 3. **Tree Map Page**:
#    - Displays an image of Vancouver showing the distribution of the tree population. 
#    - Due to the large file sizes, the real map images could not be uploaded, which caused issues with Git commits.
#    - The purpose of this feature is to give users an idea of neighborhood locations and tree density.

# 4. **Plot Page**:
#    - Offers an interactive plot where users can select a neighborhood and year to view the tree count for all species.
#    - Users can download the plot as a PNG image, zoom in on specific sections of the plot, and explore the data interactively.

# 5. **About Page**:
#    - Provides contact information for the app creator.
#    - Includes a feedback form where users can submit their name, email, and comments.
#    - A submit button displays a "Message Sent Successfully" confirmation once the feedback is submitted.
#    - If any required field is left empty, an alert will prompt the user to fill it in.
#    - A tree picture is included for visual attraction on this page.



