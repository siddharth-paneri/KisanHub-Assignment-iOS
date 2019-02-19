# KisanHub-Assignment-iOS
Interview assignment submission to 'KisanHub' by Siddharth Paneri, for the position of Senior iOS Engineer.

### App architecture
<img src = "https://github.com/siddharth-paneri/KisanHub-Assignment-iOS/blob/master/Images/Architecture.png" width="600"/>


### Features implemented
1. Fetch Weather data from API and display data accordingly in charts.
2. Store data in CoreData to be able to view offline content.


### App screenshots -
<img src = "https://github.com/siddharth-paneri/KisanHub-Assignment-iOS/blob/master/Images/IMG_1590.PNG" width="200"/>    <img src = "https://github.com/siddharth-paneri/KisanHub-Assignment-iOS/blob/master/Images/IMG_1592.PNG" width="200"/>    <img src = "https://github.com/siddharth-paneri/KisanHub-Assignment-iOS/blob/master/Images/IMG_1593.PNG" width="200"/>    <img src = "https://github.com/siddharth-paneri/KisanHub-Assignment-iOS/blob/master/Images/IMG_1594.PNG" width="200"/>
 


### Future Improvements
1. Storing such a large chunk of data takes time, Sw we can adopt Codable protocol to convert the json directly to models and show on UI and store in DB simultaneously.
2. Later when API is unreachable we can fetch from DB.
