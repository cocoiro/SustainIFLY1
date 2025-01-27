//
//  SustainIFLYApp.swift
//  SustainIFLY
//
//  Created by jiji lee!
//
import SwiftUI
import Combine

//welcome to my app! SustainIFLY raises awareness about the impact of recycling and sustainable practices. Most people are not aware of the huge impact that recycling can have, and this app tells you the impact of what you can create by recycling through a fun game!

struct SustainMain: View {
    @State private var currentPage: Page = .home
    @State private var selectedRegion: String? = nil
    @State private var plasticBottleCount: Int = 0
    @State private var timeRemaining: Int = 30
    @State private var itemCount: Int = 0

    //enum page: able to create different pages of my app! it will have five stages during the user experience. 1) welcome page, 2) map selection 3) plasticCollection 4) results 5) the finale!!
    //the enum page is a unique way of organizing the structure of my app
    enum Page {
        case home, world, collection, results, questComplete
    }
    
    //below each case corresponds to the above case scenario

    var body: some View {
        ZStack {
            switch currentPage {
            case .home:
                SustainHome(onContinue: {
                    currentPage = .world
                })

            case .world:
                SustainWorld(onRegionSelected: { region in
                    selectedRegion = region
                    currentPage = .collection
                })


            case .collection:
                if let region = selectedRegion {
                    CollectionView(
                        region: region,
                        timeRemaining: $timeRemaining,
                        itemCount: $itemCount,
                        onComplete: {
                            currentPage = .results
                        }
                    )
                }

            case .results:
                ResultsView(
                    itemCount: itemCount,
                    region: selectedRegion ?? "",
                    onComplete: {
                        currentPage = .questComplete
                    }
                )

            case .questComplete:
                QuestCompleteView()
            }
 
        }
        .animation(.easeInOut, value: currentPage)
    }
}

//first page code
struct SustainHome: View {
    let onContinue: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("SustainIFLY")//sustainIFLY logo image
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    //added the Spacer() so that the start button would be located lower on the page
                    Spacer()
                    
                    Text("Welcome to SustainIFLY!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    
                    
                    Spacer()
                    //start button so that user can get started with the game
                    Button(action: onContinue) {
                        Text("Start")
                            .font(.title2)
                            .padding()
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    //needed to adjust the postion of the button to go to the bottom of the page
                    .padding(.bottom, 50)
                    .padding(.top, 20)
                }
            }
        }
    }
    
}

//next page! this is where the user chooses where they want to clean in the world
struct SustainWorld: View {
    let onRegionSelected: (String) -> Void
    
    var body: some View {
        //adding an image of the world map, Zstack = layered stack
        ZStack{
            Image("World Map-2")
                .resizable()
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
            
            //vertical stack
            VStack {
                Spacer()
                
                Spacer() //move more down
                
                //to determine the regions that had the highest amount of trash data from the Los Angeles Times was used
                Text("Choose a region to clean up! Numbers represent metric tons per day. ")
                    .font(.title2)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .offset(x: -170, y: 110)

                Spacer()
                //learned how to horizontally stack items !
                //arranged in a row
                HStack {
                    Button(action: { onRegionSelected("US") }) {
                        Text("United States (624,700)")
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    
                    Button(action: { onRegionSelected("China") }) {
                        Text("China (520,548)")
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    
                    Button(action: { onRegionSelected("Brazil") }) {
                        Text("Brazil (149,096)")
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    
                    Button(action: { onRegionSelected("Japan") }) {
                        Text("Japan (144,466)")
                            .padding()
                            .background(Color.mint)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    
                    Button(action: { onRegionSelected("Germany") }) {
                        Text("Germany (127,816)")
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
        }
    }
}
//third page where the user actually plays the game
struct CollectionView: View {
    let region: String
    @Binding var timeRemaining: Int
    @Binding var itemCount: Int
    let onComplete: () -> Void
    
    //utilizing cases so that I can have different images appear for each user input!
    var itemName: String {
        switch region {
        case "US": return "Cigarette Filters"
        case "Germany": return "Plastic Packaging"
        case "Japan": return "Plastic Packaging"
        case "Brazil": return "Paper"
        case "China": return "Single-Use Plastics"
        default: return "Items"
        }
    }
    
    var itemImage: String {
        let imageName: String
        switch region {
        case "US": imageName = "cigaretteFilter"
        case "Germany": imageName = "plasticPackaging"
        case "Japan": imageName = "plasticPackaging"
        case "Brazil": imageName = "paper"
        case "China": imageName = "singleUsePlastics"
        default: imageName = "defaultItem"
        }
        print("Region: \(region), Resolved Image: \(imageName)") //needed to debug
        return imageName
    }

    //the text allows the user to know how many items were collected and their time remaining!
    //learned how to use GeometryReader which allows me to adjust the positioning of items
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Collect \(itemName)!")
                    .font(.title)
                    .padding()

                Text("Time Remaining: \(timeRemaining)s")
                    .font(.headline)
                
                Text("Items Collected: \(itemCount)")
                    .font(.headline)
                    .padding()

//allows the positions of the images to continue rotating around
                ZStack {
                    ForEach(0..<5, id: \ .self) { _ in
                        Image(itemImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100) //image size
                            .position(
                                x: CGFloat.random(in: 50...(geometry.size.width - 50)),
                                y: CGFloat.random(in: 100...(geometry.size.height - 150))
                            )
                            .onTapGesture {
                                itemCount += 1
                            }
                            .animation(.easeInOut(duration:3.0), value: UUID()) //slow down movement and pictures moving in and out
                        //initially had the duration to 1.0 changed it to 3.0
                    }
                }

                .onAppear {
                    print("Current Image: \(itemImage)") //trying to debug sob
                }
                
                if timeRemaining == 0 {
                    Button(action: onComplete) {
                        Text("See Results")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .onAppear(perform: startTimer)
        }
    }
//timer 30 seconds!
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
            }
        }
    }
}
//results!!
struct ResultsView: View {
    let itemCount: Int
    let region: String
    let onComplete: () -> Void

    //using different cases in order to allow the user to know what they can create with the recycled materials
    var resultMessage: String {
        switch region {
        case "US":
            if itemCount <= 40 { return "By collecting/recycling cigarette filters, you can create paper! In the U.S. collect cigarette filters and mail them to TerraCycle's Cigarette Waste Free Recycling Program. Create an account on the TerraCycle website. Just make sure the cigarettes are properly extinguished!" }
            else if itemCount <= 100 { return "By collecting/recycling cigarette filters, you can create shorts! In the U.S. collect cigarette filters and mail them to TerraCycle's Cigarette Waste Free Recycling Program. Create an account on the TerraCycle website. Just make sure the cigarettes are properly extinguished!" }
            else { return "By collecting/recycling cigarette filters, you can create jeans! In the U.S. collect cigarette filters and mail them to TerraCycle's Cigarette Waste Free Recycling Program. Create an account on the TerraCycle website. Just make sure the cigarettes are properly extinguished!" }

        case "Germany", "Japan", "China":
            if itemCount <= 30 { return "By collecting/recycling plastic packaging and single use plastics, you can create yarn! If you want to recycle plastic packaging, go to your nearest designated recycling center. Make sure to differentiate bins! In Japan, you can even go to your local convenience stores to recycle plastic products." }
            else if itemCount <= 50 { return "By collecting/recycling plastic packaging and single use plastics, you can create a t-shirt! If you want to recycle plastic packaging, go to your nearest designated recycling center. Make sure to differentiate bins! In Japan, you can even go to your local convenience stores to recycle plastic products." }
            else { return "By collecting/recycling plastic packaging and single use plastics, you can create 5-10 t-shirts! If you want to recycle plastic packaging, go to your nearest designated recycling center. Make sure to differentiate bins! In Japan, you can even go to your local convenience stores to recycle plastic products." }

        case "Brazil":
            if itemCount <= 200 { return "By collecting/recycling paper, you can create more paper! To recycle paper in Brazil, you must drop it off at your local designated recycling collection station! Make sure to recycle as Brazil has one of the lowest recycling rates in the world." }
            else { return "By collecting/recycling paper, you created a large amount of paper! To recycle paper in Brazil, you must drop it off at your local designated recycling collection station! Make sure to recycle as Brazil has one of the lowest recycling rates in the world." }

        default:
            return "You did great! Try collecting more trash to promote sustainability and the growth of the planet!"
        }
    }

    var body: some View {
        VStack {
            Text("Results")
                .font(.largeTitle)
                .padding()

            Text(resultMessage)
                .font(.title2)
                .padding()

            Button(action: onComplete) {
                Text("Complete Quest")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
    }
}

//finally! quest completed
struct QuestCompleteView: View {
    var body: some View {
        VStack {
            Text("Quest Complete!")
                .font(.largeTitle)
                .padding()

            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.yellow)

            Text("Thank you for helping the planet!")
                .font(.headline)
                .padding()
        }
    }
}
  
@main
struct SustainIFLYApp: App {
    var body: some Scene {
        WindowGroup {
            SustainMain() //main view name, this needs to be the same
        }
    }
}
    
