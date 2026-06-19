import 'package:flutter/material.dart';

class BookingEmptyState extends StatelessWidget {
  const BookingEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(Icons.cleaning_services, size: 80),

          SizedBox(height: 20),

          Text("No bookings yet"),

          SizedBox(height: 8),

          Text("Your reservations will appear here"),
        ],
      ),
    );
  }
}
