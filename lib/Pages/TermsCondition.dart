import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';

class TermsCondition extends StatelessWidget {
  const TermsCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: MyColors.bgColor,
        title: const Text(
          "Terms & Services",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Wink30 (www.wink30.com) is an information intermediary service Platform (hereinafter referred to as the Platform) that provides Users with digital asset trading and related services. The Platform provides services to Users registered with the Platform (hereinafter referred to as the Users) in accordance with the terms and conditions of this Agreement (defined below), and this Agreement shall be legally binding between the Users and the Platform. The Platform hereby reminds the Users to carefully read and fully understand the terms and conditions of this Agreement, especially those terms and conditions of this Agreement that exclude or limit the liability of the Platform and exclude or restrict the rights and interests of the Users. The Users shall read carefully and choose to accept or reject this Agreement",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Unless a User accepts all the terms and conditions of this Agreement, the User shall not be entitled to use the services provided by the Platform. If the User does not agree to the content of this Agreement or refuses to recognize the right of the Platform to make unilateral amendments to this Agreement at any time, the User shall promptly stop using and cease to access the Platform. By registering as a User of the Platform or using the services offered, a User is deemed to fully understand and fully accept all the terms and conditions of this Agreement, including any amendments that the Platform may make to this Agreement at any time.",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "For the convenience of wording in this Agreement, the Platform is collectively referred to as ”we” or other applicable forms of first-person pronouns in this Agreement. All natural persons and other visitors who log onto this Website shall be referred to as ”you” or any other applicable forms of the second-person pronouns. You and we are collectively referred to as “both parties”, and individually as “one party” herein. There is an attempt to increase the rate of winklink token, in this we can be successful as well as unsuccessful. But we  all will be done by making efforts together. You can also work for free to join us. If you take our package, then there is extra benefit. Investment risk in the market, please invest according to your status. Everyone should be benefited to all our effort.",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Thank you",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                "Wink30",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
