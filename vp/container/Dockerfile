# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This is the custom container Dockerfile for NVDLA VP:
#       1. Take the container base image from nvdla/vp;
#       2. Set environment variable;
#       3. Copy "startup.sh" script into container environment;
#       4. Make that "startup.sh" script is executed at every container startup.

# Container base image
FROM nvdla/vp

# Disable SC_SIGNAL_WRITE_CHECK_DISABLE, macro used in SystemC to decide upon checking multiple writes
# on sc_signal objects or not. Because NVDLA VP uses TLM to model module communication, not RTL signal wiring,
# multiple writes in the same delta cycle should not cause errors.
ENV SC_SIGNAL_CHECK_DISABLE=DISABLE

# Specify the path for shared libraries
ENV LD_LIBRARY_PATH=/usr/local/systemc-2.3.0/lib-linux64/

# Copy startup.sh to container environment
COPY startup.sh /startup.sh

# CMD section - executed at each container run
CMD ["/startup.sh"]
