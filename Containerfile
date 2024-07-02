FROM fedora:latest

# Install necessary packages
RUN dnf update -y && dnf install -y curl tar

# Download and extract the application to /opt/aethir
RUN mkdir /opt/aethir 
ADD https://checker-mainet-s3.s3.ap-southeast-1.amazonaws.com/eu/AethirCheckerCLI-linux-1.0.2.2.tar.gz /opt/aethir
RUN tar -zvxf /opt/aethir/AethirCheckerCLI-linux-1.0.2.2.tar.gz -C /opt/aethir/ --strip-components 1

# Ensure the binary is executable
RUN chmod +x /opt/aethir/AethirCheckerService
RUN chmod +x /opt/aethir/AethirCheckerCLI

# Set the working directory
WORKDIR /opt/aethir

# Command to run the service
CMD ["./AethirCheckerService"]
