import 'package:chat_with_gemini/MyHomePage.dart';
import 'package:chat_with_gemini/onboarding_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final pageController =PageController();
  final controller =OnboardingItems();
  
  bool isLastPage =false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        color: Colors.white,
        child: isLastPage ? getStarted() : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: (){
              pageController.jumpToPage(controller.list.length-1);
            },
            child: const Text("Skip"),),


            SmoothPageIndicator(controller: pageController, count:controller.list.length
            , effect: WormEffect(
                dotWidth: 12,
                dotHeight: 12,
                activeDotColor: Theme.of(context).colorScheme.primary
              ),onDotClicked: (index)=>{
              pageController.animateToPage(index, duration: Duration(milliseconds: 400), curve: Curves.easeIn)
              },),
            TextButton(onPressed: (){
              pageController.nextPage(duration: Duration(milliseconds: 400), curve:Curves.easeIn);
            },
              child: const Text("Next"),),
          ],
        ),
      ),
      body: PageView.builder(
        onPageChanged: (index)=>setState(() {
          isLastPage = controller.list.length -1 == index;
        }),
        controller: pageController,
          itemCount: controller.list.length,
          itemBuilder: (context,index){
          return Column(
            children: [
              SvgPicture.asset(controller.list[index].image),
              (index==1)? SizedBox(height: 15,):SizedBox(height: 75,),
              Center(child: Image.asset(controller.list[index].image_center)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(controller.list[index].title,textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w800,letterSpacing: 1.1,color: Colors.blue,),),
              ),
              SizedBox(height: 15,),
              Text(controller.list[index].description,textAlign: TextAlign.center,style: TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.w200),),
              Spacer()
            ],
          );
      }),
    );
  }
  
  
  Widget getStarted(){
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.9,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
        
      ),
        child: TextButton(onPressed:() async{
          final prefs=await SharedPreferences.getInstance();
          prefs.setBool("onBoarding", true);
          if(!mounted)return;

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
        }, child: Text("Get Started",style: TextStyle(color: Colors.white),)));
  }
}
