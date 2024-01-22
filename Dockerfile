# Use the official image as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:latest as base
WORKDIR /app
EXPOSE 80
EXPOSE 443
 
# Use SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:latest as build
WORKDIR /src
COPY ["helloworld-dotnetcore.csproj", "./"]
RUN dotnet restore "./helloworld-dotnetcore.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "helloworld-dotnetcore.csproj" -c Release -o /helloworld-dotnetcore/build
 
# Publish the application
FROM build AS publish
RUN dotnet publish "helloworld-dotnetcore.csproj" -c Release -o /helloworld-dotnetcore/publish
 
# Final stage/image
FROM base AS final
WORKDIR /app
COPY --from=publish /helloworld-dotnetcore/publish .
ENTRYPOINT ["dotnet", "helloworld-dotnetcore.dll"]
