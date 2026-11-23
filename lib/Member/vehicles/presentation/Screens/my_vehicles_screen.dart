
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

import '../../data/vehicle_repository.dart';
import '../../domain/vehicle_model.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_event.dart';
import '../bloc/vehicle_state.dart';
import '../widgets/add_vehicle_bottom_sheet.dart';

const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);
const Color _mutedColor = Color(0xFF91A0B8);
const Color _borderColor = Color(0xFFE8EDF4);
const Color _backgroundColor = Color(0xFFF5F7FB);

class MyVehiclesScreen extends StatelessWidget {
  const MyVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VehicleBloc(
        repository: VehicleRepositoryImpl(),
      )..add(VehiclesRequested()),
      child: const MyVehiclesView(),
    );
  }
}

class MyVehiclesView extends StatelessWidget {
  const MyVehiclesView({super.key});

  Future<void> _addVehicle(BuildContext context) async {
    final vehicle = await showAddVehicleBottomSheet(context);

    if (!context.mounted || vehicle == null) return;

    context.read<VehicleBloc>().add(
          VehicleAdded(vehicle),
        );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _addVehicle(BuildContext context) async {
    final vehicle = await showAddVehicleBottomSheet(context);

    if (!context.mounted || vehicle == null) return;

    context.read<VehicleBloc>().add(
          VehicleAdded(vehicle),
        );
  }

    return Scaffold(
           backgroundColor: AdminColors.page,
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
                'My Vehicles',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Manage your parking and vehicles | Ruchita | Flat 201 | A',
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
         
        ],
      ),
       floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addDocumentCategory',
        onPressed: ()
        {
           _addVehicle(context);
        },
        backgroundColor: _primaryColor,
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          'Add Vehicle',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SafeArea(
        child: BlocBuilder<VehicleBloc, VehicleState>(
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 850;

                return SingleChildScrollView(
                  padding: EdgeInsets.all(isDesktop ? 28 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // _buildHeader(context, isDesktop),

                      

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildSectionHeader(
                          context,
                          state.vehicles.length,
                        ),
                      ),

                      const SizedBox(height: 18),

                      if (state.status == VehicleStatus.loading &&
                          state.vehicles.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(
                              color: _primaryColor,
                            ),
                          ),
                        )
                      else if (state.status == VehicleStatus.failure &&
                          state.vehicles.isEmpty)
                        _buildError(context, state)
                      else if (state.vehicles.isEmpty)
                        _buildEmptyState(context)
                      else
                        _buildVehicleList(
                          state.vehicles,
                          isDesktop,
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDesktop,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor),
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(child: _headerText()),
                _addButton(context),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerText(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: _addButton(context),
                ),
              ],
            ),
    );
  }

  Widget _headerText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'My Vehicles',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: _primaryColor,
        ),
        SizedBox(height: 6),
        CommonText(
          text: 'Manage your registered vehicles',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _mutedColor,
        ),
      ],
    );
  }

  Widget _addButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _addVehicle(context),
      icon: const Icon(Icons.add, size: 19),
      label: const Text(
        'Add Vehicle',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    int count,
  ) {
    return Row(
      children: [
        const Expanded(
          child: CommonText(
            text: 'Registered Vehicles',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: _textColor,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEAF3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count ${count == 1 ? 'Vehicle' : 'Vehicles'}',
            style: const TextStyle(
              color: _primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // IconButton(
        //   tooltip: 'Refresh vehicles',
        //   onPressed: () {
        //     context.read<VehicleBloc>().add(
        //           VehiclesRefreshed(),
        //         );
        //   },
        //   icon: const Icon(
        //     Icons.refresh_rounded,
        //     color: _primaryColor,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildVehicleList(
    List<VehicleModel> vehicles,
    bool isDesktop,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = isDesktop
            ? (constraints.maxWidth > 700
                ? 340.0
                : constraints.maxWidth)
            : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: vehicles.map((vehicle) {
            return SizedBox(
              width: cardWidth,
              child: VehicleCard(vehicle: vehicle),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 45,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.directions_car_outlined,
            size: 48,
            color: _mutedColor,
          ),
          const SizedBox(height: 12),
          const CommonText(
            text: 'No Vehicles Registered',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _textColor,
          ),
          const SizedBox(height: 6),
          const CommonText(
            text: 'Add your vehicle to get started.',
            fontSize: 12,
            color: _mutedColor,
          ),
          const SizedBox(height: 18),
          _addButton(context),
        ],
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    VehicleState state,
  ) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(state.errorMessage ?? 'Unable to load vehicles'),
          TextButton(
            onPressed: () {
              context.read<VehicleBloc>().add(
                    VehiclesRequested(),
                  );
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// VEHICLE CARD
// --------------------------------------------------

class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;

  const VehicleCard({
    super.key,
    required this.vehicle,
  });

  IconData get _vehicleIcon {
    if (vehicle.vehicleType.contains('2-Wheeler')) {
      return Icons.two_wheeler;
    }

    if (vehicle.vehicleType.contains('3-Wheeler')) {
      return Icons.electric_rickshaw;
    }

    return Icons.directions_car_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEAF3),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  _vehicleIcon,
                  color: _primaryColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.makeAndModel,
                      style: const TextStyle(
                        color: _textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vehicle.vehicleType,
                      style: const TextStyle(
                        color: _mutedColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F8EC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'REGISTERED',
                  style: TextStyle(
                    color: Color(0xFF29965A),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          const Divider(
            height: 1,
            color: _borderColor,
          ),

          const SizedBox(height: 14),

          const Text(
            'LICENSE PLATE',
            style: TextStyle(
              color: _mutedColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),

          const SizedBox(height: 7),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FB),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: _borderColor),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.confirmation_number_outlined,
                  size: 17,
                  color: _primaryColor,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    vehicle.licensePlate,
                    style: const TextStyle(
                      color: _textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
