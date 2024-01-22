# Use the official image as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:latest as base
WORKDIR /app
EXPOSE 80
EXPOSE 443
 
# Use SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:latest as build
WORKDIR /src
COPY ["harness1.csproj", "./"]
RUN dotnet restore "./harness1.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "harness1.csproj" -c Release -o /app/build
 
# Publish the application
FROM build AS publish
RUN dotnet publish "harness1.csproj" -c Release -o /app/publish
 
# Final stage/image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "harness1.dll"]
