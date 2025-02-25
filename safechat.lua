-- [INSTANCES]
local SafeChatGUI = Instance.new("ScreenGui")
local SafeChat = Instance.new("Frame")
local UIAspectRatio = Instance.new("UIAspectRatioConstraint")
local ChatButton = Instance.new("ImageButton")
local Click = Instance.new("Sound")
local Hint = Instance.new("ImageLabel")
local Templates = Instance.new("Folder")
local TempBranch = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local TempButton = Instance.new("TextButton")

-- [PROPERTIES]
SafeChatGUI.Name = "SafeChatGUI"
SafeChatGUI.Parent = game.CoreGui
SafeChatGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

SafeChat.Name = "SafeChat"
SafeChat.Parent = SafeChatGUI
SafeChat.AnchorPoint = Vector2.new(0, 1)
SafeChat.BackgroundTransparency = 1.000
SafeChat.BorderColor3 = Color3.fromRGB(27, 42, 53)
SafeChat.Position = UDim2.new(0, 0, 1, 0)
SafeChat.Size = UDim2.new(1, 0, 1, 0)

UIAspectRatio.Name = "UIAspectRatio"
UIAspectRatio.Parent = SafeChat
UIAspectRatio.AspectRatio = 1.333
UIAspectRatio.DominantAxis = Enum.DominantAxis.Height

ChatButton.Name = "ChatButton"
ChatButton.Parent = SafeChat
ChatButton.AnchorPoint = Vector2.new(0, 1)
ChatButton.BackgroundTransparency = 1.000
ChatButton.BorderColor3 = Color3.fromRGB(27, 42, 53)
ChatButton.Position = UDim2.new(0.0201999992, 0, 0.777700007, 0)
ChatButton.Size = UDim2.new(0, 32, 0, 32)
ChatButton.Image = "rbxassetid://991182833"

Click.Name = "Click"
Click.Parent = ChatButton
Click.SoundId = "rbxasset://sounds/switch.mp3"
Click.Volume = 0.500

Hint.Name = "Hint"
Hint.Parent = ChatButton
Hint.AnchorPoint = Vector2.new(0.5, 0.75)
Hint.BackgroundTransparency = 1.000
Hint.BorderColor3 = Color3.fromRGB(27, 42, 53)
Hint.Position = UDim2.new(1, 5, 0, 0)
Hint.Size = UDim2.new(0.75, 0, 0.75, 0)
Hint.Visible = false
Hint.Image = "rbxasset://textures/ui/Settings/Help/XButtonDark@2x.png"

Templates.Name = "Templates"
Templates.Parent = SafeChat

TempBranch.Name = "TempBranch"
TempBranch.Parent = Templates
TempBranch.AnchorPoint = Vector2.new(0, 0.5)
TempBranch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TempBranch.BackgroundTransparency = 1.000
TempBranch.BorderColor3 = Color3.fromRGB(27, 42, 53)
TempBranch.Position = UDim2.new(1, 5, 0.5, 0)
TempBranch.Size = UDim2.new(0, 140, 0, 24)
TempBranch.Visible = false
TempBranch.ZIndex = 2

UIListLayout.Parent = TempBranch
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Padding = UDim.new(0, 5)

TempButton.Name = "TempButton"
TempButton.Parent = Templates
TempButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TempButton.BorderColor3 = Color3.fromRGB(62, 62, 62)
TempButton.Size = UDim2.new(0, 140, 0, 24)
TempButton.Visible = false
TempButton.ZIndex = 2
TempButton.AutoButtonColor = false
TempButton.Font = Enum.Font.Cartoon
TempButton.Text = "ROOT"
TempButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TempButton.TextSize = 12.000
TempButton.TextStrokeTransparency = 0.950
TempButton.TextTransparency = 0.250

-- [SCRIPTS]
local function IVZZGZO_fake_script()
	local script = Instance.new('LocalScript', SafeChat)

	local userInputService = game:GetService("UserInputService")
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local textChatService = game:GetService("TextChatService")
	local guiService = game:GetService("GuiService")
	
	local chatFrame = script.Parent
	local chatButton = chatFrame:WaitForChild("ChatButton")
	local clickSound = chatButton:WaitForChild("Click")
	local hintLabel = chatButton:WaitForChild("Hint")
	
	local safeChatData = {
		Label = "ROOT",
		Branches = {
			{
				Label = "Hello",
				Branches = {
					{
						Label = "Hi",
						Branches = {
							{
								Label = "Hi there!",
								Branches = {}
							},
							{
								Label = "Hi everyone	",
								Branches = {}
							}
						}
					},
					{
						Label = "Howdy",
						Branches = {
							{
								Label = "Howdy partner!",
								Branches = {}
							}
						}
					},
					{
						Label = "Greetings",
						Branches = {
							{
								Label = "Greetings everyone",
								Branches = {}
							},
							{
								Label = "Greetings robloxians!",
								Branches = {}
							},
							{
								Label = "Seasons greetings!",
								Branches = {}
							}
						}
					},
					{
						Label = "Welcome",
						Branches = {
							{
								Label = "Welcome to my place",
								Branches = {}
							},
							{
								Label = "Welcome to our base",
								Branches = {}
							},
							{
								Label = "Welcome to my barbecque",
								Branches = {}
							}
						}
					},
					{
						Label = "Hey there!",
						Branches = {}
					},
					{
						Label = "What's up?",
						Branches = {
							{
								Label = "How are you doing?",
								Branches = {}
							},
							{
								Label = "How's it going?",
								Branches = {}
							},
							{
								Label = "What's new?",
								Branches = {}
							}
						}
					},
					{
						Label = "Good day",
						Branches = {
							{
								Label = "Good morning",
								Branches = {}
							},
							{
								Label = "Good afternoon",
								Branches = {}
							},
							{
								Label = "Good evening",
								Branches = {}
							},
							{
								Label = "Good night",
								Branches = {}
							}
						}
					},
					{
						Label = "Silly",
						Branches = {
							{
								Label = "Waaaaaaaz up?!",
								Branches = {}
							},
							{
								Label = "Hullo!",
								Branches = {}
							},
							{
								Label = "Behold greatness, mortals!",
								Branches = {}
							}
						}
					},
					{
						Label = "Holidays",
						Branches = {
							{
								Label = "Happy New Year!",
								Branches = {}
							},
							{
								Label = "Happy Valentine's Day!",
								Branches = {}
							},
							{
								Label = "Beware the Ides of March!",
								Branches = {}
							},
							{
								Label = "Happy Easter!",
								Branches = {}
							},
							{
								Label = "Happy 4th of July!",
								Branches = {}
							},
							{
								Label = "Happy Thanksgiving!",
								Branches = {}
							},
							{
								Label = "Happy Halloween!",
								Branches = {}
							},
							{
								Label = "Happy Hanukkah!",
								Branches = {}
							},
							{
								Label = "Merry Christmas!",
								Branches = {}
							},
							{
								Label = "Happy Holidays!",
								Branches = {}
							}
						}
					}
				}
			},
			{
				Label = "Goodbye",
				Branches = {
					{
						Label = "Good Night",
						Branches = {
							{
								Label = "Sweet dreams",
								Branches = {}
							},
							{
								Label = "Go to sleep!",
								Branches = {}
							},
							{
								Label = "Lights out!",
								Branches = {}
							},
							{
								Label = "Bedtime",
								Branches = {}
							}
						}
					},
					{
						Label = "Later",
						Branches = {
							{
								Label = "See ya later",
								Branches = {}
							},
							{
								Label = "Later gator!",
								Branches = {}
							},
							{
								Label = "See you tomorrow",
								Branches = {}
							}
						}
					},
					{
						Label = "Bye",
						Branches = {
							{
								Label = "Hasta la bye bye!",
								Branches = {}
							}
						}
					},
					{
						Label = "I'll be right back",
						Branches = {}
					},
					{
						Label = "I have to go",
						Branches = {}
					},
					{
						Label = "Farewell",
						Branches = {
							{
								Label = "Take care",
								Branches = {}
							},
							{
								Label = "Have a nice day",
								Branches = {}
							},
							{
								Label = "Goodluck!",
								Branches = {}
							},
							{
								Label = "Ta-ta for now!",
								Branches = {}
							}
						}
					},
					{
						Label = "Peace",
						Branches = {
							{
								Label = "Peace out!",
								Branches = {}
							},
							{
								Label = "Peace dudes!",
								Branches = {}
							},
							{
								Label = "Rest in pieces!",
								Branches = {}
							}
						}
					},
					{
						Label = "Silly",
						Branches = {
							{
								Label = "To the batcave!",
								Branches = {}
							},
							{
								Label = "Over and out!",
								Branches = {}
							},
							{
								Label = "Happy trails!",
								Branches = {}
							},
							{
								Label = "I've got to book it!",
								Branches = {}
							},
							{
								Label = "Tootles!",
								Branches = {}
							},
							{
								Label = "Smell you later!",
								Branches = {}
							},
							{
								Label = "GG!",
								Branches = {}
							},
							{
								Label = "My house is on fire! gtg.",
								Branches = {}
							}
						}
					}
				}
			},
			{
				Label = "Friend",
				Branches = {
					{
						Label = "Wanna be friends?",
						Branches = {}
					},
					{
						Label = "Follow me",
						Branches = {
							{
								Label = "Come to my place!",
								Branches = {}
							},
							{
								Label = "Come to my base!",
								Branches = {}
							},
							{
								Label = "Follow me, team!",
								Branches = {}
							}
						}
					},
					{
						Label = "Your place is cool",
						Branches = {
							{
								Label = "Your place is fun",
								Branches = {}
							},
							{
								Label = "Your place is awesome",
								Branches = {}
							},
							{
								Label = "Your place looks good",
								Branches = {}
							}
						}
					},
					{
						Label = "Thank you",
						Branches = {
							{
								Label = "Thanks for playing",
								Branches = {}
							},
							{
								Label = "Thanks for visiting",
								Branches = {}
							},
							{
								Label = "Thanks for everything",
								Branches = {}
							},
							{
								Label = "No thank you",
								Branches = {}
							}
						}
					},
					{
						Label = "No problem",
						Branches = {
							{
								Label = "Don't worry",
								Branches = {}
							},
							{
								Label = "That's ok",
								Branches = {}
							}
						}
					},
					{
						Label = "You are ...",
						Branches = {
							{
								Label = "You are great!",
								Branches = {}
							},
							{
								Label = "You are good!",
								Branches = {}
							},
							{
								Label = "You are cool!",
								Branches = {}
							},
							{
								Label = "You are funny!",
								Branches = {}
							},
							{
								Label = "You are silly!",
								Branches = {}
							},
							{
								Label = "You are awesome!",
								Branches = {}
							}
						}
					},
					{
						Label = "I like ...",
						Branches = {
							{
								Label = "I like your name",
								Branches = {}
							},
							{
								Label = "I like your shirt",
								Branches = {}
							},
							{
								Label = "I like your place",
								Branches = {}
							},
							{
								Label = "I like your style",
								Branches = {}
							}
						}
					},
					{
						Label = "Sorry",
						Branches = {
							{
								Label = "My bad!",
								Branches = {}
							},
							{
								Label = "I'm sorry",
								Branches = {}
							},
							{
								Label = "Whoops!",
								Branches = {}
							},
							{
								Label = "Please forgive me",
								Branches = {}
							},
							{
								Label = "I forgive you",
								Branches = {}
							}
						}
					}
				}
			},
			{
				Label = "Questions",
				Branches = {
					{
						Label = "Who?",
						Branches = {
							{
								Label = "Who wants to be my friend?",
								Branches = {}
							},
							{
								Label = "Who wants to be on my team?",
								Branches = {}
							},
							{
								Label = "Who made this brilliant game?",
								Branches = {}
							}
						}
					},
					{
						Label = "What?",
						Branches = {
							{
								Label = "What is your favorite animal?",
								Branches = {}
							},
							{
								Label = "What is your favorite game?",
								Branches = {}
							},
							{
								Label = "What is your favorite movie?",
								Branches = {}
							},
							{
								Label = "What is your favorite TV show?",
								Branches = {}
							},
							{
								Label = "What is your favorite music?",
								Branches = {}
							},
							{
								Label = "What are your hobbies?",
								Branches = {}
							}
						}
					},
					{
						Label = "When?",
						Branches = {
							{
								Label = "When are you online?",
								Branches = {}
							},
							{
								Label = "When is the new version coming out?",
								Branches = {}
							},
							{
								Label = "When can we play again?",
								Branches = {}
							},
							{
								Label = "When will your place be done?",
								Branches = {}
							}
						}
					},
					{
						Label = "Where?",
						Branches = {
							{
								Label = "Where do you want to go?",
								Branches = {}
							},
							{
								Label = "Where are you going?",
								Branches = {}
							},
							{
								Label = "Where am I?!",
								Branches = {}
							}
						}
					},
					{
						Label = "How?",
						Branches = {
							{
								Label = "How are you today?",
								Branches = {}
							},
							{
								Label = "How did you make this cool place?",
								Branches = {}
							}
						}
					},
					{
						Label = "Can I...",
						Branches = {
							{
								Label = "Can I have a tour?",
								Branches = {}
							},
							{
								Label = "Can I be on your team?",
								Branches = {}
							},
							{
								Label = "Can I be your friend?",
								Branches = {}
							},
							{
								Label = "Can I try something?",
								Branches = {}
							}
						}
					}
				}
			},
			{
				Label = "Answers",
				Branches = {
					{
						Label = "You need help?",
						Branches = {
							{
								Label = "Check out the news section",
								Branches = {}
							},
							{
								Label = "Check out the help section",
								Branches = {}
							},
							{
								Label = "Read the wiki!",
								Branches = {}
							},
							{
								Label = "All the answers are in the wiki!",
								Branches = {}
							}
						}
					},
					{
						Label = "Some people ...",
						Branches = {
							{
								Label = "Me",
								Branches = {}
							},
							{
								Label = "Not me",
								Branches = {}
							},
							{
								Label = "You",
								Branches = {}
							},
							{
								Label = "All of us",
								Branches = {}
							},
							{
								Label = "Everyone but you",
								Branches = {}
							},
							{
								Label = "Builderman!",
								Branches = {}
							},
							{
								Label = "Telamon!",
								Branches = {}
							}
						}
					},
					{
						Label = "Time ...",
						Branches = {
							{
								Label = "In the morning",
								Branches = {}
							},
							{
								Label = "In the afternoon",
								Branches = {}
							},
							{
								Label = "At night",
								Branches = {}
							},
							{
								Label = "Tomorrow",
								Branches = {}
							},
							{
								Label = "This week",
								Branches = {}
							},
							{
								Label = "This month",
								Branches = {}
							},
							{
								Label = "Sometime",
								Branches = {}
							},
							{
								Label = "Sometimes",
								Branches = {}
							},
							{
								Label = "Whenever you want",
								Branches = {}
							},
							{
								Label = "Never",
								Branches = {}
							}
						}
					},
					{
						Label = "Animals",
						Branches = {
							{
								Label = "Cats",
								Branches = {
									{
										Label = "Lion",
										Branches = {}
									},
									{
										Label = "Tiger",
										Branches = {}
									},
									{
										Label = "Leopard",
										Branches = {}
									},
									{
										Label = "Cheetah",
										Branches = {}
									}
								}
							},
							{
								Label = "Dogs",
								Branches = {
									{
										Label = "Wolves",
										Branches = {}
									},
									{
										Label = "Beagle",
										Branches = {}
									},
									{
										Label = "Collie",
										Branches = {}
									},
									{
										Label = "Dalmatian",
										Branches = {}
									},
									{
										Label = "Poodle",
										Branches = {}
									},
									{
										Label = "Spaniel",
										Branches = {}
									},
									{
										Label = "Shepherd",
										Branches = {}
									},
									{
										Label = "Terrier",
										Branches = {}
									},
									{
										Label = "Retriever",
										Branches = {}
									}
								}
							},
							{
								Label = "Horses",
								Branches = {
									{
										Label = "Ponies",
										Branches = {}
									},
									{
										Label = "Stallions",
										Branches = {}
									}
								}
							},
							{
								Label = "Reptiles",
								Branches = {
									{
										Label = "Dinosaurs",
										Branches = {}
									},
									{
										Label = "Lizards",
										Branches = {}
									},
									{
										Label = "Snakes",
										Branches = {}
									},
									{
										Label = "Turtles!",
										Branches = {}
									}
								}
							},
							{
								Label = "Hamster",
								Branches = {}
							},
							{
								Label = "Monkey",
								Branches = {}
							},
							{
								Label = "Bears",
								Branches = {}
							},
							{
								Label = "Fish",
								Branches = {
									{
										Label = "Goldfish",
										Branches = {}
									},
									{
										Label = "Sharks",
										Branches = {}
									},
									{
										Label = "Sea Bass",
										Branches = {}
									},
									{
										Label = "Halibut",
										Branches = {}
									}
								}
							},
							{
								Label = "Birds",
								Branches = {
									{
										Label = "Eagles",
										Branches = {}
									},
									{
										Label = "Penguins",
										Branches = {}
									},
									{
										Label = "Turkeys",
										Branches = {}
									}
								}
							},
							{
								Label = "Elephants",
								Branches = {}
							},
							{
								Label = "Mythical Beasts",
								Branches = {
									{
										Label = "Dragons",
										Branches = {}
									},
									{
										Label = "Unicorns",
										Branches = {}
									},
									{
										Label = "Sea Serpents",
										Branches = {}
									},
									{
										Label = "Sphinx",
										Branches = {}
									},
									{
										Label = "Cyclops",
										Branches = {}
									},
									{
										Label = "Minotaurs",
										Branches = {}
									},
									{
										Label = "Goblins",
										Branches = {}
									},
									{
										Label = "Honest Politicians",
										Branches = {}
									},
									{
										Label = "Ghosts",
										Branches = {}
									},
									{
										Label = "Scylla and Charybdis",
										Branches = {}
									}
								}
							}
						}
					},
					{
						Label = "Games",
						Branches = {
							{
								Label = "Roblox",
								Branches = {
									{
										Label = "BrickBattle",
										Branches = {}
									},
									{
										Label = "Community Building",
										Branches = {}
									},
									{
										Label = "Roblox Minigames",
										Branches = {}
									}
								}
							},
							{
								Label = "Action",
								Branches = {}
							},
							{
								Label = "Puzzle",
								Branches = {}
							},
							{
								Label = "Strategy",
								Branches = {}
							},
							{
								Label = "Racing",
								Branches = {}
							},
							{
								Label = "RPG",
								Branches = {}
							},
							{
								Label = "Board games",
								Branches = {
									{
										Label = "Chess",
										Branches = {}
									},
									{
										Label = "Checkers",
										Branches = {}
									},
									{
										Label = "Settlers of Catan",
										Branches = {}
									},
									{
										Label = "Tigris and Euphrates",
										Branches = {}
									},
									{
										Label = "El Grande",
										Branches = {}
									},
									{
										Label = "Stratego",
										Branches = {}
									},
									{
										Label = "Carcassonne",
										Branches = {}
									}
								}
							}
						}
					},
					{
						Label = "Sports",
						Branches = {
							{
								Label = "Hockey",
								Branches = {}
							},
							{
								Label = "Soccer",
								Branches = {}
							},
							{
								Label = "Football",
								Branches = {}
							},
							{
								Label = "Baseball",
								Branches = {}
							},
							{
								Label = "Basketball",
								Branches = {}
							},
							{
								Label = "Volleyball",
								Branches = {}
							},
							{
								Label = "Tennis",
								Branches = {}
							},
							{
								Label = "Watersports",
								Branches = {
									{
										Label = "Surfing",
										Branches = {}
									},
									{
										Label = "Swimming",
										Branches = {}
									},
									{
										Label = "Water Polo",
										Branches = {}
									}
								}
							},
							{
								Label = "Winter sports",
								Branches = {
									{
										Label = "Skiing",
										Branches = {}
									},
									{
										Label = "Snowboarding",
										Branches = {}
									},
									{
										Label = "Sledding",
										Branches = {}
									},
									{
										Label = "Skating",
										Branches = {}
									}
								}
							},
							{
								Label = "Adventure",
								Branches = {
									{
										Label = "Rock climbing",
										Branches = {}
									},
									{
										Label = "Hiking",
										Branches = {}
									},
									{
										Label = "Fishing",
										Branches = {}
									}
								}
							},
							{
								Label = "Wacky",
								Branches = {
									{
										Label = "Foosball",
										Branches = {}
									},
									{
										Label = "Calvinball",
										Branches = {}
									},
									{
										Label = "Croquet",
										Branches = {}
									},
									{
										Label = "Cricket",
										Branches = {}
									},
									{
										Label = "Dodgeball",
										Branches = {}
									},
									{
										Label = "Squash",
										Branches = {}
									}
								}
							}
						}
					},
					{
						Label = "Movies/TV",
						Branches = {
							{
								Label = "Science Fiction",
								Branches = {}
							},
							{
								Label = "Animated",
								Branches = {
									{
										Label = "Anime",
										Branches = {}
									}
								}
							},
							{
								Label = "Comedy",
								Branches = {}
							},
							{
								Label = "Romantic",
								Branches = {}
							},
							{
								Label = "Action",
								Branches = {}
							},
							{
								Label = "Fantasy",
								Branches = {}
							}
						}
					},
					{
						Label = "Music",
						Branches = {
							{
								Label = "Country",
								Branches = {}
							},
							{
								Label = "Jazz",
								Branches = {}
							},
							{
								Label = "Rap",
								Branches = {}
							},
							{
								Label = "Hip-hop",
								Branches = {}
							},
							{
								Label = "Techno",
								Branches = {}
							},
							{
								Label = "Classical",
								Branches = {}
							},
							{
								Label = "Pop",
								Branches = {}
							},
							{
								Label = "Rock",
								Branches = {}
							}
						}
					},
					{
						Label = "Hobbies",
						Branches = {
							{
								Label = "Computers",
								Branches = {
									{
										Label = "Building computers",
										Branches = {}
									},
									{
										Label = "Videogames",
										Branches = {}
									},
									{
										Label = "Coding",
										Branches = {}
									},
									{
										Label = "Hacking",
										Branches = {}
									}
								}
							},
							{
								Label = "The Internet",
								Branches = {
									{
										Label = "lol. teh internets!",
										Branches = {}
									}
								}
							},
							{
								Label = "Dance",
								Branches = {}
							},
							{
								Label = "Gynastics",
								Branches = {}
							},
							{
								Label = "Martial Arts",
								Branches = {
									{
										Label = "Karate",
										Branches = {}
									},
									{
										Label = "Judo",
										Branches = {}
									},
									{
										Label = "Taikwon Do",
										Branches = {}
									},
									{
										Label = "Wushu",
										Branches = {}
									},
									{
										Label = "Street fighting",
										Branches = {}
									}
								}
							},
							{
								Label = "Listening to music",
								Branches = {}
							},
							{
								Label = "Music lessons",
								Branches = {
									{
										Label = "Playing in my band",
										Branches = {}
									},
									{
										Label = "Playing piano",
										Branches = {}
									},
									{
										Label = "Playing guitar",
										Branches = {}
									},
									{
										Label = "Playing violin",
										Branches = {}
									},
									{
										Label = "Playing drums",
										Branches = {}
									},
									{
										Label = "Playing a weird instrument",
										Branches = {}
									}
								}
							},
							{
								Label = "Arts and crafts",
								Branches = {}
							}
						}
					},
					{
						Label = "Location",
						Branches = {
							{
								Label = "USA",
								Branches = {
									{
										Label = "West",
										Branches = {
											{
												Label = "Alaska",
												Branches = {}
											},
											{
												Label = "Arizona",
												Branches = {}
											},
											{
												Label = "California",
												Branches = {}
											},
											{
												Label = "Colorado",
												Branches = {}
											},
											{
												Label = "Hawaii",
												Branches = {}
											},
											{
												Label = "Idaho",
												Branches = {}
											},
											{
												Label = "Montana",
												Branches = {}
											},
											{
												Label = "Nevada",
												Branches = {}
											},
											{
												Label = "New Mexico",
												Branches = {}
											},
											{
												Label = "Oregon",
												Branches = {}
											},
											{
												Label = "Utah",
												Branches = {}
											},
											{
												Label = "Washington",
												Branches = {}
											},
											{
												Label = "Wyoming",
												Branches = {}
											}
										}
									},
									{
										Label = "Midwest",
										Branches = {
											{
												Label = "Illinois",
												Branches = {}
											},
											{
												Label = "Indiana",
												Branches = {}
											},
											{
												Label = "Iowa",
												Branches = {}
											},
											{
												Label = "Kansas",
												Branches = {}
											},
											{
												Label = "Michigan",
												Branches = {}
											},
											{
												Label = "Minnesota",
												Branches = {}
											},
											{
												Label = "Missouri",
												Branches = {}
											},
											{
												Label = "Nebraska",
												Branches = {}
											},
											{
												Label = "North Dakota",
												Branches = {}
											},
											{
												Label = "Ohio",
												Branches = {}
											},
											{
												Label = "South Dakota",
												Branches = {}
											},
											{
												Label = "Wisconsin",
												Branches = {}
											}
										}
									},
									{
										Label = "Northeast",
										Branches = {
											{
												Label = "Connecticut",
												Branches = {}
											},
											{
												Label = "Delaware",
												Branches = {}
											},
											{
												Label = "Maine",
												Branches = {}
											},
											{
												Label = "Maryland",
												Branches = {}
											},
											{
												Label = "Massachusetts",
												Branches = {}
											},
											{
												Label = "New Hampshire",
												Branches = {}
											},
											{
												Label = "New Jersey",
												Branches = {}
											},
											{
												Label = "New York",
												Branches = {}
											},
											{
												Label = "Pennsylvania",
												Branches = {}
											},
											{
												Label = "Rhode Island",
												Branches = {}
											},
											{
												Label = "Vermont",
												Branches = {}
											},
											{
												Label = "Virginia",
												Branches = {}
											},
											{
												Label = "West Virginia",
												Branches = {}
											}
										}
									},
									{
										Label = "South",
										Branches = {
											{
												Label = "Alabama",
												Branches = {}
											},
											{
												Label = "Arkansas",
												Branches = {}
											},
											{
												Label = "Florida",
												Branches = {}
											},
											{
												Label = "Georgia",
												Branches = {}
											},
											{
												Label = "Kentucky",
												Branches = {}
											},
											{
												Label = "Louisiana",
												Branches = {}
											},
											{
												Label = "Mississippi",
												Branches = {}
											},
											{
												Label = "North Carolina",
												Branches = {}
											},
											{
												Label = "Oklahoma",
												Branches = {}
											},
											{
												Label = "South Carolina",
												Branches = {}
											},
											{
												Label = "Tennessee",
												Branches = {}
											},
											{
												Label = "Texas",
												Branches = {}
											}
										}
									}
								}
							},
							{
								Label = "Canada",
								Branches = {
									{
										Label = "Alberta",
										Branches = {}
									},
									{
										Label = "British Columbia",
										Branches = {}
									},
									{
										Label = "Manitoba",
										Branches = {}
									},
									{
										Label = "New Brunswick",
										Branches = {}
									},
									{
										Label = "Newfoundland",
										Branches = {}
									},
									{
										Label = "Northwest Territories",
										Branches = {}
									},
									{
										Label = "Nova Scotia",
										Branches = {}
									},
									{
										Label = "Nunavut",
										Branches = {}
									},
									{
										Label = "Ontario",
										Branches = {}
									},
									{
										Label = "Prince Edward Island",
										Branches = {}
									},
									{
										Label = "Quebec",
										Branches = {}
									},
									{
										Label = "Saskatchewan",
										Branches = {}
									},
									{
										Label = "Yukon",
										Branches = {}
									}
								}
							},
							{
								Label = "Mexico",
								Branches = {}
							},
							{
								Label = "Central America",
								Branches = {}
							},
							{
								Label = "Europe",
								Branches = {
									{
										Label = "Great Britain",
										Branches = {
											{
												Label = "England",
												Branches = {}
											},
											{
												Label = "Scotland",
												Branches = {}
											},
											{
												Label = "Wales",
												Branches = {}
											},
											{
												Label = "Northern Ireland",
												Branches = {}
											}
										}
									},
									{
										Label = "France",
										Branches = {}
									},
									{
										Label = "Germany",
										Branches = {}
									},
									{
										Label = "Spain",
										Branches = {}
									},
									{
										Label = "Italy",
										Branches = {}
									},
									{
										Label = "Poland",
										Branches = {}
									},
									{
										Label = "Switzerland",
										Branches = {}
									},
									{
										Label = "Greece",
										Branches = {}
									},
									{
										Label = "Romania",
										Branches = {}
									}
								}
							},
							{
								Label = "Asia",
								Branches = {
									{
										Label = "China",
										Branches = {}
									},
									{
										Label = "India",
										Branches = {}
									},
									{
										Label = "Japan",
										Branches = {}
									},
									{
										Label = "Korea",
										Branches = {}
									}
								}
							},
							{
								Label = "South America",
								Branches = {
									{
										Label = "Argentina",
										Branches = {}
									},
									{
										Label = "Brazil",
										Branches = {}
									}
								}
							},
							{
								Label = "Africa",
								Branches = {
									{
										Label = "Eygpt",
										Branches = {}
									},
									{
										Label = "Swaziland",
										Branches = {}
									}
								}
							},
							{
								Label = "Australia",
								Branches = {}
							},
							{
								Label = "Middle East",
								Branches = {}
							},
							{
								Label = "Antarctica",
								Branches = {}
							}
						}
					},
					{
						Label = "Age",
						Branches = {
							{
								Label = "Rugrat",
								Branches = {}
							},
							{
								Label = "Kid",
								Branches = {}
							},
							{
								Label = "Teen",
								Branches = {}
							},
							{
								Label = "Twenties",
								Branches = {}
							},
							{
								Label = "Old",
								Branches = {}
							},
							{
								Label = "Ancient",
								Branches = {}
							},
							{
								Label = "Mesozoic	",
								Branches = {}
							}
						}
					},
					{
						Label = "Mood",
						Branches = {
							{
								Label = "Good",
								Branches = {}
							},
							{
								Label = "Great!",
								Branches = {}
							},
							{
								Label = "Not bad",
								Branches = {}
							},
							{
								Label = "Sad",
								Branches = {}
							},
							{
								Label = "Hyper",
								Branches = {}
							},
							{
								Label = "Chill",
								Branches = {}
							}
						}
					},
					{
						Label = "Boy",
						Branches = {}
					},
					{
						Label = "Girl",
						Branches = {}
					}
				}
			},
			{
				Label = "Game",
				Branches = {
					{
						Label = "Let's build",
						Branches = {}
					},
					{
						Label = "Let's battle",
						Branches = {}
					},
					{
						Label = "Nice one!",
						Branches = {}
					},
					{
						Label = "So far so good!",
						Branches = {}
					},
					{
						Label = "Lucky shot!",
						Branches = {}
					},
					{
						Label = "Oh man!",
						Branches = {}
					}
				}
			},
			{
				Label = "Silly",
				Branches = {
					{
						Label = "Muahahahaha!",
						Branches = {}
					},
					{
						Label = "1337",
						Branches = {
							{
								Label = "i r teh pwnz0r!",
								Branches = {}
							},
							{
								Label = "w00t!",
								Branches = {}
							},
							{
								Label = "z0mg h4x!",
								Branches = {}
							},
							{
								Label = "ub3rR0xXorzage!",
								Branches = {}
							},
							{
								Label = "all your base are belong to me!",
								Branches = {}
							}
						}
					}
				}
			},
			{
				Label = "Yes",
				Branches = {
					{
						Label = "Absolutely!",
						Branches = {}
					},
					{
						Label = "Rock on!",
						Branches = {}
					},
					{
						Label = "Totally!",
						Branches = {}
					},
					{
						Label = "Juice!",
						Branches = {}
					}
				}
			},
			{
				Label = "No",
				Branches = {
					{
						Label = "Ummm. No.",
						Branches = {}
					},
					{
						Label = "...",
						Branches = {}
					}
				}
			},
			{
				Label = "Ok",
				Branches = {
					{
						Label = "Well... ok",
						Branches = {}
					},
					{
						Label = "Sure",
						Branches = {}
					}
				}
			},
			{
				Label = ":-)",
				Branches = {
					{
						Label = ":-(",
						Branches = {}
					},
					{
						Label = ":D",
						Branches = {}
					},
					{
						Label = ":-O",
						Branches = {}
					},
					{
						Label = "lol",
						Branches = {}
					}
				}
			}
		}
	}
	local templates = chatFrame:WaitForChild("Templates")
	local branchTemplate = templates:WaitForChild("TempBranch")
	local buttonTemplate = templates:WaitForChild("TempButton")
	
	local chatNavigation = nil
	
	local function resetElement(element)
		if element:IsA("Frame") then
			element.Visible = false
		elseif element:IsA("TextButton") then
			element.BackgroundColor3 = Color3.new(1, 1, 1)
		end
		for _, child in pairs(element:GetChildren()) do
			resetElement(child)
		end
	end
	
	local function buildChatTree(chatNode)
		local branchFrame = branchTemplate:Clone()
		branchFrame.Name = "Branches"
		local selectedButton = nil
	
		for index, branch in ipairs(chatNode.Branches) do
			local label = branch.Label
			local button = buttonTemplate:Clone()
			button.Name = label
			button.Text = label
			button.LayoutOrder = index
			button.Visible = true
	
			local subBranchFrame = buildChatTree(branch)
			subBranchFrame.Parent = button
			button.Parent = branchFrame
	
			local function highlightButton()
				if selectedButton then
					resetElement(selectedButton)
				end
				selectedButton = button
				button.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
				subBranchFrame.Visible = true
			end
	
			local function onButtonClick()
				local shouldSendMessage = true
				if userInputService.TouchEnabled and not subBranchFrame.Visible and #subBranchFrame:GetChildren() > 1 then
					subBranchFrame.Visible = true
					shouldSendMessage = false
				end
				if shouldSendMessage then
					local textChannel = textChatService:FindFirstChild("RBXGeneral", true)
					if textChannel and textChannel:IsA("TextChannel") then
						textChannel:SendAsync(label)
					end
					clickSound:Play()
					chatButton.Image = "rbxassetid://991182833"
					resetElement(chatNavigation)
					if guiService.SelectedObject then
						guiService.SelectedObject = nil
						guiService:RemoveSelectionGroup("SafeChatNav")
					end
				end
			end
	
			button.MouseEnter:Connect(highlightButton)
			button.SelectionGained:Connect(highlightButton)
			button.MouseButton1Down:Connect(onButtonClick)
		end
		return branchFrame
	end
	
	chatNavigation = buildChatTree(safeChatData)
	chatNavigation.Parent = chatButton
	local isChatHovered = false
	
	local function onChatHoverEnter()
		chatButton.Image = "rbxassetid://991182834"
		isChatHovered = true
	end
	
	local function onChatHoverExit()
		chatButton.Image = "rbxassetid://991182833"
		isChatHovered = false
	end
	
	local function onChatClick()
		if isChatHovered then
			chatNavigation.Visible = true
			chatButton.Image = "rbxassetid://991182832"
			if userInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 then
				guiService:AddSelectionParent("SafeChatNav", chatButton)
				guiService.SelectedObject = chatButton
			end
		end
	end
	
	chatButton.MouseButton1Down:Connect(function()
		chatButton.Image = "rbxassetid://991182832"
	end)
	
	chatButton.MouseEnter:Connect(onChatHoverEnter)
	chatButton.MouseLeave:Connect(onChatHoverExit)
	chatButton.MouseButton1Up:Connect(onChatClick)
	
	if guiService:IsTenFootInterface() then
		hintLabel.Visible = true
	else
		hintLabel.Visible = userInputService:GetLastInputType().Name == "Gamepad1"
		userInputService.LastInputTypeChanged:Connect(function(inputType)
			hintLabel.Visible = inputType.Name == "Gamepad1"
		end)
	end
	
	local function onInputBegan(input)
		if input.KeyCode == Enum.KeyCode.LeftControl then
			script.Enabled = false
            SafeChatGUI:Destroy()
            script:Destroy()
		end
	end
	
	userInputService.InputBegan:Connect(onInputBegan)
end
coroutine.wrap(IVZZGZO_fake_script)()
