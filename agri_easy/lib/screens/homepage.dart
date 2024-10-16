import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:agri_easy/providers/language_provider.dart';
import 'package:provider/provider.dart';

final Logger logger = Logger();

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the LanguageProvider to get the selected language
    final languageProvider = Provider.of<LanguageProvider>(context);
    String currentLanguage = languageProvider.locale.languageCode;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/main1.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main content

          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Text(
                    currentLanguage == 'en'
                        ? 'Agri - Easy'
                        : currentLanguage == 'hi'
                            ? 'कृषि - आसान'
                            : currentLanguage == 'ta'
                                ? 'விவசாய - எளிதாக்கப்பட்டது'
                                : 'Agri - Easy',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 33, 50, 0),
                      fontSize: 55,
                      fontFamily: 'Lobster',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(bottom: 25),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    currentLanguage == 'en'
                        ? 'Agriculture made easy'
                        : currentLanguage == 'hi'
                            ? "कृषि सरल बनाया गया"
                            : currentLanguage == 'ta'
                                ? "விவசாயம் எளிதாக்கப்பட்டது"
                                : "Agriculture made easy",
                    style: const TextStyle(
                      fontFamily: 'Lobster',
                      color: Color.fromARGB(255, 220, 246, 160),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0, top: 40),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset(
                    'assets/images/sprout1.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    currentLanguage == 'en'
                        ? "The agricultural industry is a critical component of our global economy, and farmers face numerous challenges, including crop diseases that can lead to significant losses. To help farmers manage these challenges more effectively, we've developed a new app that uses AI and machine learning to predict crop diseases and provide other important information that farmers need."
                        : currentLanguage == 'hi'
                            ? "कृषि उद्योग हमारी वैश्विक अर्थव्यवस्था का एक महत्वपूर्ण घटक है, और किसानों के सामने कई चुनौतियां होती हैं, जिसमें फसलों के रोग शामिल हैं जो महत्वपूर्ण नुकसान का कारण बन सकते हैं। किसानों को इन चुनौतियों को अधिक प्रभावी ढंग से संभालने में मदद करने के लिए, हमने एक नई ऐप विकसित की है जो कृषि उपयुक्तता और मशीन सीखने का उपयोग करके किसानों के लिए फसलों के रोगों का पूर्वानुमान करने और अन्य महत्वपूर्ण जानकारी प्रदान करता है।"
                            : currentLanguage == 'ta'
                                ? "விவசாய தொழில் போக்கு எங்கள் உயிர்ப்புகள் போன்ற பல்வேறு புரியும், பசுமையை மிகுதியாக்க வேண்டும். இவற்றை நாங்கள் பரிமாறியும். மாட்டையும் உங்களுக்கு பிடித்த அவலம் தேர்வுகளை பாதுகாக்கவும். எங்கள் பொருள்கள் மார்க்கிங் மற்றும் பரிவர்த்தனைக்கு மிகுதியானவைகள் ஆகும்."
                                : "The agricultural industry is a critical component of our global economy, and farmers face numerous challenges, including crop diseases that can lead to significant losses. To help farmers manage these challenges more effectively, we've developed a new app that uses AI and machine learning to predict crop diseases and provide other important information that farmers need.",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 220, 246, 160),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.asset(
                              'assets/images/camera1.png', // Replace with the path to your first image
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.asset(
                              'assets/images/pests.png', // Replace with the path to your second image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        currentLanguage == 'en'
                            ? "Our app utilizes a powerful ML model trained with a vast dataset of plant disease images, allowing users to simply take a photo and receive instant, accurate disease diagnosis. A valuable tool for farmers and plant enthusiasts, helping to identify and manage diseases early for better crop health."
                            : currentLanguage == 'hi'
                                ? "हमारा ऐप एक शक्तिशाली एमएल मॉडल का उपयोग करता है जिसे विभिन्न पौधों के रोग छवियों के विशाल डेटासेट से प्रशिक्षित किया गया है, जिससे उपयोगकर्ताओं को बस एक फोटो लेने और तुरंत, सटीक रोग निदान प्राप्त करने में मदद मिलती है। किसानों और पौधे प्रेमियों के लिए एक मूल्यवान उपकरण, जो बेहतर फसल स्वास्थ्य के लिए रोगों की पहचान और प्रबंधन में मदद करता है।"
                                : currentLanguage == 'ta'
                                    ? "எங்கள் செயலி பல்வேறு செடி நோய் படங்களை உள்ளடக்கிய மாபெரும் தரவுத்தொகுப்பிலிருந்து பயிற்சியாளராக உள்ள ஒரு சக்திவாய்ந்த எம்.எல். மாதிரியை பயன்படுத்துகிறது, இது பயனர்கள் ஒரு புகைப்படத்தை எடுத்து உடனே, துல்லியமான நோய் கண்டறிதலை பெற உதவுகிறது. இது விவசாயிகள் மற்றும் செடி ஆர்வலர்களுக்கான ஒரு மதிப்புமிக்க கருவி, இது சிறந்த பயிர் ஆரோக்கியத்திற்கு நோய்களை அடையாளம் காணும் மற்றும் நிர்வகிக்கும் விதத்தில் உதவுகிறது."
                                    : 'Agri - Easy'
                                        "Our app utilizes a powerful ML model trained with a vast dataset of plant disease images, allowing users to simply take a photo and receive instant, accurate disease diagnosis. A valuable tool for farmers and plant enthusiasts, helping to identify and manage diseases early for better crop health.",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 220, 246, 160),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        'assets/images/cloudy.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        currentLanguage == 'en'
                            ? "Our app provides farmers with accurate weather information for their current location and future forecasts. With up-to-date weather data, farmers can make informed decisions about planting, irrigation, and crop management, maximizing their yields and minimizing risks. A valuable tool for farmers to optimize their farming practices and leverage weather information for better crop outcomes."
                            : currentLanguage == 'hi'
                                ? "हमारा ऐप किसानों को उनके वर्तमान स्थान के लिए सटीक मौसम जानकारी और भविष्य के पूर्वानुमान प्रदान करता है। अद्यतित मौसम डेटा के साथ, किसान बोने, सिंचाई और फसल प्रबंधन के बारे में सूचित निर्णय लेने में मदद करता है, अपने उत्पादन को अधिकतम करने और जोखिम को कम करने। किसानों के लिए एक मौलिक उपकरण उनके खेती की प्रथाओं को अनुकूलित करने और उत्पादन के बेहतर परिणामों के लिए मौसम जानकारी का उपयोग करने के लिए।"
                                : currentLanguage == 'ta'
                                    ? "எங்கள் செயலி விவசாயிகளுக்கு அவர்களின் தற்போதைய இடத்திற்கான துல்லியமான காலநிலை தகவல்களையும் எதிர்காலத்தின் முன்னறிவிப்புகளையும் வழங்குகிறது. புதுப்பிக்கப்படுகிற காலநிலை தரவுகளுடன், விவசாயிகள் விதை நடுதல், பாசனம் மற்றும் பயிர் நிர்வாகம் குறித்த விழிப்புணர்வான முடிவுகளை எடுக்க உதவுகிறது, அவர்கள் உற்பத்தியை அதிகரிக்கவும் மற்றும் ஆபத்தை குறைக்கவும். விவசாயிகளுக்கான ஒரு அடிப்படை கருவி, இது அவர்களது விவசாய நடைமுறைகளை சிறப்புபடுத்த மற்றும் உற்பத்தி தொடர்பான மேம்பட்ட முடிவுகளைப் பெற காலநிலை தகவல்களைப் பயன்படுத்துகிறது."
                                    : "Our app provides farmers with accurate weather information for their current location and future forecasts. With up-to-date weather data, farmers can make informed decisions about planting, irrigation, and crop management, maximizing their yields and minimizing risks. A valuable tool for farmers to optimize their farming practices and leverage weather information for better crop outcomes.",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 220, 246, 160),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                  left: 5,
                  right: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 130,
                                width: 130,
                                child: Image.asset(
                                  'assets/images/chat.png', // Replace with the path to your first image
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  currentLanguage == 'en'
                                      ? "Our inbuilt chat bot is a smart agricultural assistant that provides quick and accurate answers to farmers' questions about farming practices, crop management, weather, pests, and more."
                                      : currentLanguage == 'hi'
                                          ? "हमारा अंतर्निहित चैट बॉट कृषि सहायक है जो किसानों के सवालों के लिए त्वरित और सटीक उत्तर प्रदान करता है, खेती विधियों, फसल प्रबंधन, मौसम, कीट और अधिक।"
                                          : currentLanguage == 'ta'
                                              ? "எங்கள் உள்ளூர் சாவு பாடல் சேவை பொறுப்பாக விவசாய உதவி என்பது கிரோதத்துக்களுக்காக மின்னணு மற்றும் குறைப்படுத்தப்பட்ட புதிய விவசாய குறிப்புகள் பெறலாம், பசுமையினை அதிகரிப்பது, பழமையாக்கம், காட்சிப்படுத்தல் மற்றும் செயல்திறன் தேவையானதாக அதை பரிசீலித்து வழங்குகிறது."
                                              : "Our inbuilt chat bot is a smart agricultural assistant that provides quick and accurate answers to farmers' questions about farming practices, crop management, weather, pests, and more.",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'roboto',
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 220, 246, 160),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 150,
                                width: 150,
                                child: Image.asset(
                                  'assets/images/shopping-cart.png', // Replace with the path to your second image
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                currentLanguage == 'en'
                                    ? "Our products page offers a curated selection of top-quality pesticides and fertilizers for farmers. With a focus on effectiveness and sustainability, our products help farmers protect and nourish their crops for optimal growth and yield."
                                    : currentLanguage == 'hi'
                                        ? "हमारे उत्पाद पृष्ठ पर किसानों के लिए उच्च-गुणवत्ता वाले कीटनाशक और उर्वरकों का एक चयनित संग्रह प्रदान किया जाता है। प्रभावकारी और पारिस्थितिकता के लिए बनाए गए हमारे उत्पाद किसानों की फसलों को संरक्षित और पोषित करने में मदद करते हैं।"
                                        : currentLanguage == 'ta'
                                            ? "உங்களுக்கு பிடித்த விவசாய விவசாய நிறுவனங்கள் பண்புகளை அளித்துக்கொள்ளும் கீடநாசகங்களும் உரவாக்கப்பட்ட உர்வகளும் என்றும் எளிதாக்கப்பட்ட ஒரு தேர்வு செய்கின்றனர். எங்கள் பொருள்கள் குடைப்பாடு மற்றும் பரிவர்த்தனைக்கு கூடுதல் முறையாக வாழ்க்கையில் காப்பாற்றுகின்றனர்."
                                            : "Our products page offers a curated selection of top-quality pesticides and fertilizers for farmers. With a focus on effectiveness and sustainability, our products help farmers protect and nourish their crops for optimal growth and yield.",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'roboto',
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 220, 246, 160),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.only(bottom: 100),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        'assets/images/info.png', // Replace with the path to your third image
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentLanguage == 'en'
                          ? "Explore our app for comprehensive agricultural insights and tools. From disease prediction and weather updates to chatbot assistance and product recommendations, our app is your go-to resource for smart and efficient farming practices."
                          : currentLanguage == 'hi'
                              ? "विस्तृत कृषि जानकारी और उपकरणों के लिए हमारे ऐप का अन्वेषण करें। फसलों के रोग पूर्वानुमान और मौसम अद्यतन से लेकर चैटबॉट सहायता और उत्पाद सिफारिशों तक, हमारा ऐप आपके लिए बुद्धिमान और कुशल खेती प्रथाओं का संसाधन है।"
                              : currentLanguage == 'ta'
                                  ? "விவசாய அறிவியல் மற்றும் கருவிகளையும் நீங்கள் பயன்படுத்த முடியும் எங்கள் ஆப்பினை அரசியல் பலம் மற்றும் பாதுகாப்பின்முறை தகவல்களின் மூலம் தரவுகளை வழங்குகிறது. நெடுங்கால பயன்பாடுகளை அதிகரிக்கும், பரிந்துரைக்கப்பட்டு, உங்களுக்கு நல்ல உதவுகிறது கிரீடிங் மற்றும் சிக்கல்கள்."
                                  : "Explore our app for comprehensive agricultural insights and tools. From disease prediction and weather updates to chatbot assistance and product recommendations, our app is your go-to resource for smart and efficient farming practices.",
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontFamily: 'roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 220, 246, 160),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
