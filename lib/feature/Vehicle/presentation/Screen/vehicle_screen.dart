
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:society_management/feature/Vehicle/Presentation/Bloc/vehicle_bloc.dart';
import 'package:society_management/feature/Vehicle/presentation/bloc/VehicleModel.dart';
import 'package:society_management/feature/Vehicle/presentation/widget/add_vehicle_bottom_sheet.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);

class VehicleScreen extends StatelessWidget {
  final List<String> members;
  final List<String> parkingSlots;

  const VehicleScreen({
    super.key,
    this.members = const [
      'Rahul Sharma',
      'Priya Shah',
      'Amit Patel',
    ],
    this.parkingSlots = const [
      'A - 101 - A-01',
      'A - 102 - A-02',
      'B - 201 - B-01',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VehicleBloc(),
      child: _VehicleView(
        members: members,
        parkingSlots: parkingSlots,
      ),
    );
  }
}

class _VehicleView extends StatefulWidget {
  final List<String> members;
  final List<String> parkingSlots;

  const _VehicleView({
    required this.members,
    required this.parkingSlots,
  });

  @override
  State<_VehicleView> createState() => _VehicleViewState();
}

class _VehicleViewState extends State<_VehicleView> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // OPEN REGISTER VEHICLE BOTTOM SHEET

  Future<void> _openAddVehicle() async {
    if (widget.members.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add members before registering vehicles.'),
        ),
      );
      return;
    }

    final vehicle = await showAddVehicleBottomSheet(
      context,
      members: widget.members,
      parkingSlots: widget.parkingSlots,
    );

    if (!mounted || vehicle == null) return;

    context.read<VehicleBloc>().add(
      VehicleCreated(vehicle),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vehicle registered successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // SEARCH

  List<VehicleModel> _filterVehicles(
    List<VehicleModel> vehicles,
  ) {
    if (_searchQuery.trim().isEmpty) return vehicles;

    final query = _searchQuery.toLowerCase().trim();

    return vehicles.where((vehicle) {
      return vehicle.memberName.toLowerCase().contains(query) ||
          vehicle.licensePlate.toLowerCase().contains(query) ||
          vehicle.makeModel.toLowerCase().contains(query) ||
          vehicle.vehicleType.toLowerCase().contains(query) ||
          vehicle.parkingSlot.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.page,

      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addVehicle',
        onPressed: _openAddVehicle,
        backgroundColor: _primaryColor,
        icon: const Icon(
          Icons.directions_car_outlined,
          color: Colors.white,
        ),
        label: const Text(
          'Register Vehicle',
          style: TextStyle(color: Colors.white),
        ),
      ),

      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  const LinearGradient(
                colors: [
                  Color(0xFFEC4899),
                  Color(0xFFF97316),
                ],
              ).createShader(bounds),
              child: const Text(
                'Registered Vehicles',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Manage all registered society vehicles',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        backgroundColor: AdminColors.page,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFFEC4899),
              size: 25,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          final filteredVehicles =
              _filterVehicles(state.vehicles);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),

                // SUMMARY CARDS
                _buildSummaryCards(state),

               

                // SEARCH
                _buildSearch(),

                const SizedBox(height: 16),

                // VEHICLE LIST
                _buildVehicleList(
                  filteredVehicles,
                  state.vehicles,
                ),

                const SizedBox(height: 90),
              ],
            ),
          );
        },
      ),
    );
  }

  // SUMMARY CARDS

  Widget _buildSummaryCards(VehicleState state) {
    final cards = [
      _VehicleSummaryData(
        'Total Vehicles',
        state.totalVehicles,
        Icons.directions_car_outlined,
        Colors.blue,
      ),
      _VehicleSummaryData(
        '2-Wheeler',
        state.twoWheelerCount,
        Icons.two_wheeler,
        Colors.orange,
      ),
      _VehicleSummaryData(
        '4-Wheeler',
        state.fourWheelerCount,
        Icons.directions_car,
        const Color(0xFFE93691),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (context, index) {
        final item = cards[index];

        return Container(
          padding: const EdgeInsets.only(left: 12,right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.grey.shade100,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.count}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _textColor,
                      ),
                    ),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // SEARCH FIELD

  Widget _buildSearch() {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          hintText: 'Search vehicles...',
          hintStyle: const TextStyle(
            fontSize: 12,
            color: Color(0xFF91A0B8),
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 19,
            color: Color(0xFF91A0B8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Color(0xFFDCE3EF),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Color(0xFFDCE3EF),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: _primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  // VEHICLE LIST

  Widget _buildVehicleList(
    List<VehicleModel> filteredVehicles,
    List<VehicleModel> allVehicles,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vehicle List',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),

          const SizedBox(height: 14),

          if (filteredVehicles.isEmpty)
            _buildEmptyState(allVehicles.isEmpty)
          else
            ...List.generate(
              filteredVehicles.length,
              (index) {
                final vehicle = filteredVehicles[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildVehicleCard(vehicle, index),
                );
              },
            ),

          if (filteredVehicles.isNotEmpty) ...[
            const Divider(height: 12),
            Text(
              'Showing ${filteredVehicles.length} of ${allVehicles.length} vehicles',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // VEHICLE CARD

  Widget _buildVehicleCard(
    VehicleModel vehicle,
    int index,
  ) {
    final isTwoWheeler = vehicle.vehicleType == '2-Wheeler';

    final typeColor = isTwoWheeler
        ? Colors.orange
        : Colors.blue;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF1E5EC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  isTwoWheeler
                      ? Icons.two_wheeler
                      : Icons.directions_car_outlined,
                  color: typeColor,
                  size: 23,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.licensePlate,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _textColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      vehicle.makeModel.isEmpty
                          ? 'Model not specified'
                          : vehicle.makeModel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              _buildVehicleTypeBadge(vehicle.vehicleType),
               Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => _confirmDelete(vehicle),
              tooltip: 'Delete Vehicle',
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
                size: 20,
              ),
            ),
          ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 12),

          _vehicleInfoRow(
            Icons.person_outline,
            'Member',
            vehicle.memberName,
          ),

          const SizedBox(height: 9),

          _vehicleInfoRow(
            Icons.local_parking_outlined,
            'Parking Slot',
            vehicle.parkingSlot.isEmpty
                ? 'Not Assigned'
                : vehicle.parkingSlot,
          ),

         

         
        ],
      ),
    );
  }

  Widget _vehicleInfoRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF91A0B8),
        ),
        const SizedBox(width: 7),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ),
      ],
    );
  }

  // VEHICLE TYPE BADGE

  Widget _buildVehicleTypeBadge(String type) {
    final isTwoWheeler = type == '2-Wheeler';

    final color = isTwoWheeler
        ? Colors.orange
        : Colors.blue;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  // EMPTY STATE

  Widget _buildEmptyState(bool isCompletelyEmpty) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 35,
        horizontal: 12,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              isCompletelyEmpty
                  ? Icons.directions_car_outlined
                  : Icons.search_off,
              size: 42,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              isCompletelyEmpty
                  ? 'No Vehicles Registered'
                  : 'No Matching Vehicles Found',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              isCompletelyEmpty
                  ? 'Click Register Vehicle to add your first vehicle.'
                  : 'Try searching with another keyword.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DELETE CONFIRMATION

  void _confirmDelete(VehicleModel vehicle) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Vehicle'),
          content: Text(
            'Are you sure you want to delete ${vehicle.licensePlate}?',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.read<VehicleBloc>().add(
                  VehicleDeleted(vehicle),
                );

                Navigator.pop(dialogContext);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

// SUMMARY MODEL

class _VehicleSummaryData {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  _VehicleSummaryData(
    this.title,
    this.count,
    this.icon,
    this.color,
  );
}
